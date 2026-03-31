Class {
	#name : 'GeminiChatGenerator',
	#superclass : 'Object',
	#instVars : [
		'chat',
		'generationModel',
		'functionsSet',
		'requestJSONObject',
		'httpClient',
		'requestTimestamp',
		'responseOrError',
		'retryDelaySeconds'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatGenerator class >> defaultModel [

	^ GeminiModel default
]

{ #category : 'Not categorized' }
GeminiChatGenerator class >> defaultModel: model [

	GeminiModel default: model
]

{ #category : 'Not categorized' }
GeminiChatGenerator class >> forChat: chat [

	^ self basicNew initializeWithChat: chat
]

{ #category : 'Not categorized' }
GeminiChatGenerator class >> modelNamed: aModelName [

	^self models detect: [:one | one name = aModelName]
]

{ #category : 'Not categorized' }
GeminiChatGenerator class >> models [

	^ GeminiModel all
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> generate [

	1 to: 100 do: [ :number |
		self sendRequest.
		(chat userMessages last applyFunctionsInLastGeneratedContentUsing: functionsSet inContext: (GeminiFunctionCallContext model: generationModel filePaths: chat filePaths))
			ifTrue: [ chat updateLastModelTextSegment ]
			ifFalse: [ ^ self ] ].
	Error signal: 'Maximum number of generations reached'
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> handleError [

	((responseOrError errorCode = SstErrorConstants::SstReceiveError) and: [
		responseOrError errorObject sstIsMessage])
			ifTrue: [| responseErrorObject |
				responseErrorObject :=
					responseOrError errorObject contents asUnicodeString
						ifNotEmpty: [:contentsString | (NeoJSONReader fromString: contentsString) first at: 'error']
						ifEmpty: [nil].
				GeminiLog current addEntry: (
					GeminiLogEntryAPIError
						timestamp: requestTimestamp
						model: generationModel
						requestObject: requestJSONObject
						responseHeader: responseOrError errorObject header
						responseErrorObject: responseErrorObject).
				((responseOrError errorObject header statusCode = 429 and: [
					responseErrorObject notNil]) 
						ifTrue:[
							((responseErrorObject at: 'details' ifAbsent: [ #() ] ) detect: [:detail | (detail at: '@type') = 'type.googleapis.com/google.rpc.RetryInfo'] ifNone: [nil])])
								ifNil:[ responseOrError raise ]
								ifNotNil: [:retryInfo |
									retryDelaySeconds := ScaledDecimal fromString: (retryInfo at: 'retryDelay') allButLast.
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
GeminiChatGenerator >> handleResponse [

	| responseObjects stream |

	chat userMessages last addNewGeneratedContent.
	chat updateLastModelTextSegment.
	responseObjects := OrderedCollection new.
	stream := GeminiJSONObjectArrayStream on: (GeminiPeekableStream on: (GeminiCharacterGraphemeStream on: (GeminiUTF8DecodingStream on: (GeminiStreamedByteMessageReadStream on: responseOrError)))).
	[ stream atEnd ] whileFalse: [
		| responseObject firstCandidate firstCandidateContent contentParts |
		responseObject := responseObjects add: stream next.
		(responseObject includesKey: 'usageMetadata') ifTrue: [
			chat usageMetadata: (responseObject at: 'usageMetadata') ].
		firstCandidate := (responseObject at: 'candidates' ifAbsent: [ ^ self ]) first.
		firstCandidateContent := firstCandidate at: 'content' ifAbsent: [ nil ].
		firstCandidateContent ifNil:[  Error signal: 'Model stopped, reason: ',(firstCandidate at: 'finishReason') ].
		(firstCandidateContent at: 'role') = 'model' ifFalse: [ Error signal: 'Expected generated content to have the role "model"' ].
		contentParts := (firstCandidateContent at: 'parts' ifAbsent: [ #() ]) collect: [ :partJSON | GeminiAbstractContentPart fromJSON: partJSON ].
		chat userMessages last addModelContentPartsToLastGeneratedContent: contentParts.
		chat updateLastModelTextSegment ].
	GeminiLog current addEntry: (GeminiLogEntryGeneratedContent timestamp: requestTimestamp model: generationModel requestObject: requestJSONObject
		responseHeader: responseOrError header responseObjects: responseObjects).
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> handleRetryDelay [

	httpClient shutDown.
	httpClient := nil.
	chat changedTextSegments.
	(Delay forSeconds: retryDelaySeconds) wait.
	retryDelaySeconds := nil
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> initializeWithChat: initialChat [

	self initialize.
	chat := initialChat.
	generationModel := chat model.
	functionsSet := GeminiFunctionsSet new.
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> prepareRequestJSONObject [

	requestJSONObject := EsOrderedDictionary
		with: 'contents' -> (Array streamContents: [ :stream |
			chat userMessages do: [ :userMessage |
				stream nextPut: userMessage userContentJSON.
				userMessage generatedContents do: [ :generatedContent |
					stream nextPut: generatedContent modelContentJSON.
					generatedContent userContentJSON ifNotNil: [ :userContentJSON |
						stream nextPut: userContentJSON ] ] ] ])
		with: 'tools' -> (EsOrderedDictionary with: 'functionDeclarations' -> functionsSet functionDeclarationsJSON)
		with: 'systemInstruction' -> (EsOrderedDictionary with: 'parts' -> { EsOrderedDictionary with: 'text' -> chat systemInstruction })
		with: 'generationConfig' -> (EsOrderedDictionary with: 'thinkingConfig' -> (EsOrderedDictionary with: 'includeThoughts' -> true))
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> retryDelaySeconds [

	^ retryDelaySeconds
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> sendRequest [

	self prepareRequestJSONObject.
	[
		1 to: 10 do: [ :number |
			(httpClient := SstHttpClient forTransportScheme: generationModel url localEndpointUrl transport)
				proxyEnabled: true.
			requestTimestamp := DateAndTime now.
			responseOrError := httpClient post: (GeminiJSONWriter toString: requestJSONObject) asUtf8Bytes typed: 'application/json;charset=utf-8' at: generationModel url streaming: true.
			responseOrError isSstError ifTrue: [
				self handleError
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
GeminiChatGenerator >> startGenerating [

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
