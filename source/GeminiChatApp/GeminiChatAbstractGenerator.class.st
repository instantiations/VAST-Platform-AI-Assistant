Class {
	#name : 'GeminiChatAbstractGenerator',
	#superclass : 'Object',
	#instVars : [
		'chat',
		'generationModel',
		'functionsSet',
		'requestJSONObject',
		'httpClient',
		'requestTimestamp',
		'responseOrError',
		'retryDelaySeconds',
		'shouldStop'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator class >> forChat: chat [

	^ self basicNew initializeWithChat: chat
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> generate [

	1 to: 100 do: [ :number |
		self sendRequest.
		(chat userMessages last applyFunctionsInLastGeneratedContentUsing: functionsSet inContext: (GeminiFunctionCallContext model: generationModel filePaths: chat filePaths))
			ifTrue: [ chat updateLastModelTextSegment ]
			ifFalse: [ ^ self ].
		shouldStop
			ifTrue: [ ^ self ] ].
	Error signal: 'Maximum number of generations reached'
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> handleError [

	((responseOrError errorCode = SstErrorConstants::SstReceiveError) and: [
		responseOrError errorObject sstIsMessage])
			ifTrue: [| responseErrorObject |
				responseErrorObject :=
					responseOrError errorObject contents asUnicodeString
						ifNotEmpty: [:contentsString | self parseErrorResponseMessage: (NeoJSONReader fromString: contentsString) ]
						ifEmpty: [nil].
				GeminiLog current addEntry: (
					GeminiLogEntryAPIError
						timestamp: requestTimestamp
						model: generationModel
						requestObject: requestJSONObject
						responseHeader: responseOrError errorObject header
						responseErrorObject: responseErrorObject).
				(responseOrError errorObject header statusCode = 429 and: [
					responseErrorObject notNil]) 
						ifTrue:[
							self parseRetryDelaySecondsFrom: responseErrorObject].
				retryDelaySeconds
					ifNil:[ responseOrError raise ]
					ifNotNil: [
						self handleRetryDelay]]
			ifFalse: [
				GeminiLog current addEntry: (
					GeminiLogEntrySstError
						timestamp: requestTimestamp
						model: generationModel
						requestObject: requestJSONObject
						errorCode: responseOrError errorCode
						errorObject: responseOrError errorObject).
				responseOrError raise]
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> handleResponse [

	| responseObjects characterStream stream |

	chat userMessages last addNewGeneratedContent.
	chat updateLastModelTextSegment.
	responseObjects := OrderedCollection new.
	characterStream := GeminiPeekableStream on: (GeminiCharacterGraphemeStream on: (GeminiUTF8DecodingStream on: (GeminiStreamedByteMessageReadStream on: responseOrError))).
	stream := self jsonResponseStreamOn: characterStream.
	[ stream atEnd | shouldStop ] whileFalse: [
		| responseObject contentParts |
		responseObject := responseObjects add: stream next.
		contentParts := self parseResponse: responseObject.
		contentParts ifNotEmpty: [
			chat userMessages last addModelContentPartsToLastGeneratedContent: contentParts.
			chat updateLastModelTextSegment ] ].
	GeminiLog current addEntry: (GeminiLogEntryGeneratedContent timestamp: requestTimestamp model: generationModel requestObject: requestJSONObject
		responseHeader: responseOrError header responseObjects: responseObjects).
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> handleRetryDelay [

	| retryDelayEndDateAndTime |

	httpClient shutDown.
	httpClient := nil.
	chat changedTextSegments.
	retryDelayEndDateAndTime := DateAndTime now + (Duration seconds: retryDelaySeconds).
	[ (DateAndTime now >= retryDelayEndDateAndTime) | shouldStop ] whileFalse: [
		(Delay forMilliseconds: 500) wait ].
	retryDelaySeconds := nil
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> initializeWithChat: initialChat [

	self initialize.
	chat := initialChat.
	generationModel := chat model.
	functionsSet := GeminiFunctionsSet new.
	shouldStop := false.
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> isStopping [

	^ shouldStop
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> jsonResponseStreamOn: characterStream [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> parseErrorResponseMessage: responseJSON [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> parseResponse: responseObject [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> parseRetryDelaySecondsFrom: responseErrorObject [

	"Default: do nothing"
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> prepareRequestJSONObject [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> requestCredentials [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> requestHeaders [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> retryDelaySeconds [

	^ retryDelaySeconds
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> sendRequest [

	self prepareRequestJSONObject.
	[
		1 to: 10 do: [ :number |
			(httpClient := SstHttpClient forTransportScheme: self url localEndpointUrl transport)
				proxyEnabled: true.
			requestTimestamp := DateAndTime now.
			responseOrError := httpClient post: (GeminiJSONWriter toString: requestJSONObject) asUtf8Bytes typed: 'application/json;charset=utf-8' at: self url
				using: self requestCredentials withHeaders: self requestHeaders streaming: true.
			responseOrError isSstError ifTrue: [
				self handleError.
				shouldStop ifTrue: [
					^ self ].
			] ifFalse: [
				self handleResponse.
				^ self ] ].
		Error signal: 'Failed sending request 10 times'
	] ensure: [
		httpClient ifNotNil: [
			httpClient shutDown.
			httpClient := nil ] ]
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> startGenerating [

	[
		[
			chat generationError: nil.
			self generate]
				when: ExError
				do: [:error |
					chat generationError: (GeminiChatGenerationErrorInfo forError: error withGenerator: self).
					error exitWith: nil].
		chat changedTextSegments.
		chat generationFinished]
			fork
]

{ #category : 'Not categorized' }
GeminiChatAbstractGenerator >> stopGenerating [

	shouldStop := true
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatAbstractGenerator >> url [

	self subclassResponsibility
]
