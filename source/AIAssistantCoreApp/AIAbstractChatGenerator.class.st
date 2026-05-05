Class {
	#name : 'AIAbstractChatGenerator',
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
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractChatGenerator class >> forChat: chat [

	^ self basicNew initializeWithChat: chat
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractChatGenerator >> addGeneratedContentParts: contentParts [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> generate [

	1 to: 100 do: [ :number |
		self sendRequest.
		(chat userMessages last applyFunctionsInLastGeneratedContentUsing: functionsSet inContext: (AIFunctionCallContext model: generationModel filePaths: chat filePaths))
			ifTrue: [ CwAppContext default syncExecInUI: [ chat updateLastModelTextSegment ] ]
			ifFalse: [ ^ self ].
		shouldStop
			ifTrue: [ ^ self ] ].
	Error signal: 'Maximum number of generations reached'
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> handleError [

	((responseOrError errorCode = SstErrorConstants::SstReceiveError) and: [
		responseOrError errorObject sstIsMessage])
			ifTrue: [| responseErrorObject |
				responseErrorObject :=
					responseOrError errorObject contents asUnicodeString
						ifNotEmpty: [:contentsString | self parseErrorResponseMessage: (NeoJSONReader fromString: contentsString) ]
						ifEmpty: [nil].
				AIChatGenerationLog current addEntry: (
					AIChatGenerationLogEntryAPIError
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
				AIChatGenerationLog current addEntry: (
					AIChatGenerationLogEntrySstError
						timestamp: requestTimestamp
						model: generationModel
						requestObject: requestJSONObject
						errorCode: responseOrError errorCode
						errorObject: responseOrError errorObject).
				responseOrError raise]
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> handleResponse [

	| responseObjects characterStream stream |

	CwAppContext default syncExecInUI: [
		chat userMessages last addNewGeneratedContent.
		chat updateLastModelTextSegment ].
	responseObjects := OrderedCollection new.
	characterStream := AIPeekableStream on: (AICharacterGraphemeStream on: (AIUTF8DecodingStream on: (AIStreamedByteMessageReadStream on: responseOrError))).
	stream := self jsonResponseStreamOn: characterStream.
	[ stream atEnd | shouldStop ] whileFalse: [
		| responseObject contentParts |
		responseObject := responseObjects add: stream next.
		contentParts := self parseResponse: responseObject.
		contentParts ifNotEmpty: [
			CwAppContext default syncExecInUI: [
				self addGeneratedContentParts: contentParts.
				chat updateLastModelTextSegment ] ] ].
	AIChatGenerationLog current addEntry: (AIChatGenerationLogEntryGeneratedContent timestamp: requestTimestamp model: generationModel requestObject: requestJSONObject
		responseHeader: responseOrError header responseObjects: responseObjects).
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> handleRetryDelay [

	| retryDelayEndDateAndTime |

	httpClient shutDown.
	httpClient := nil.
	retryDelayEndDateAndTime := DateAndTime now + (Duration seconds: retryDelaySeconds).
	CwAppContext default syncExecInUI: [
		chat changedTextSegments ].
	[ (DateAndTime now >= retryDelayEndDateAndTime) | shouldStop ] whileFalse: [
		(Delay forMilliseconds: 500) wait ].
	retryDelaySeconds := nil.	
	CwAppContext default syncExecInUI: [
		chat changedTextSegments ]
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> initializeWithChat: initialChat [

	self initialize.
	chat := initialChat.
	generationModel := chat model.
	functionsSet := AIFunctionsSet new.
	shouldStop := false.
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> isStopping [

	^ shouldStop
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractChatGenerator >> jsonResponseStreamOn: characterStream [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractChatGenerator >> parseErrorResponseMessage: responseJSON [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractChatGenerator >> parseResponse: responseObject [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractChatGenerator >> parseRetryDelaySecondsFrom: responseErrorObject [

	"Default: do nothing"
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractChatGenerator >> prepareRequestJSONObject [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> retryDelaySeconds [

	^ retryDelaySeconds
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> sendRequest [

	self prepareRequestJSONObject.
	[
		1 to: 10 do: [ :number |
			(httpClient := SstHttpClient forTransportScheme: generationModel urlAPI localEndpointUrl transport)
				proxyEnabled: true.
			requestTimestamp := DateAndTime now.
			responseOrError := httpClient post: (AIJSONWriter toString: requestJSONObject) asUtf8Bytes typed: 'application/json;charset=utf-8' at: generationModel urlAPI
				using: generationModel requestCredentials withHeaders: generationModel requestHeaders streaming: true.
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
AIAbstractChatGenerator >> startGenerating [

	chat generationError: nil.
	[
		[
			self generate
		] when: ExError do: [ :error |
			CwAppContext default syncExecInUI: [
				chat generationError: (AIChatGenerationErrorInfo forError: error withGenerator: self) ].
			error exitWith: nil ].
		CwAppContext default syncExecInUI: [
			chat
				changedTextSegments;
				generationFinished ]
	] fork
]

{ #category : 'Not categorized' }
AIAbstractChatGenerator >> stopGenerating [

	shouldStop := true
]
