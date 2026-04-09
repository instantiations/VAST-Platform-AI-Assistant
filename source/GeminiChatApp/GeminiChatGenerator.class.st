Class {
	#name : 'GeminiChatGenerator',
	#superclass : 'GeminiChatAbstractGenerator',
	#classInstVars : [
		'models'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatGenerator class >> models [

	models ifNil: [
		models := {
			GeminiModel name: 'gemini-3.1-pro-preview-customtools' label: '3.1 Pro Preview Custom Tools' contextWindowSize: 1048576.
			GeminiModel name: 'gemini-3.1-pro-preview' label: '3.1 Pro Preview' contextWindowSize: 1048576.
			GeminiModel name: 'gemini-3.1-flash-lite-preview' label: '3.1 Flash-Lite Preview' contextWindowSize: 1048576.
			GeminiModel name: 'gemini-3-flash-preview' label: '3 Flash Preview' contextWindowSize: 1048576.
			GeminiModel name: 'gemini-2.5-pro' label: '2.5 Pro' contextWindowSize: 1048576.
			GeminiModel name: 'gemini-2.5-flash' label: '2.5 Flash' contextWindowSize: 1048576.
			GeminiModel name: 'gemini-2.5-flash-lite' label: '2.5 Flash-Lite' contextWindowSize: 1048576 } ].
	^ models
]

{ #category : 'Not categorized' }
GeminiChatGenerator class >> reset [

	models := nil
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatGenerator >> jsonResponseStreamOn: characterStream [

	^ GeminiJSONObjectArrayStream on: characterStream
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatGenerator >> parseErrorResponseMessage: responseJSON [

	^ responseJSON first at: 'error'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatGenerator >> parseResponse: responseObject [

	| firstCandidate firstCandidateContent |

	(responseObject includesKey: 'usageMetadata')
		ifTrue: [|metadata|
			metadata := responseObject at: 'usageMetadata'.
			chat tokenUsage: (GeminiTokenUsage prompt: (metadata at: 'promptTokenCount') total:  (metadata at: 'totalTokenCount'))].
	firstCandidate := (responseObject at: 'candidates' ifAbsent: [^self]) first.
	firstCandidateContent := firstCandidate at: 'content' ifAbsent: [nil].
	firstCandidateContent
		ifNil: [Error signal: 'Model stopped, reason: ' , (firstCandidate at: 'finishReason')].
	(firstCandidateContent at: 'role') = 'model'
		ifFalse: [Error signal: 'Expected generated content to have the role "model"'].
	^(firstCandidateContent at: 'parts' ifAbsent: [#()])
		collect: [:partJSON | GeminiAbstractContentPart fromJSON: partJSON]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatGenerator >> parseRetryDelaySecondsFrom: responseErrorObject [

	| details retryInfo |

	details := responseErrorObject at: 'details' ifAbsent: [ ^ self ].
	retryInfo := details detect: [ :detail | (detail at: '@type') = 'type.googleapis.com/google.rpc.RetryInfo' ] ifNone: [ ^ self ].
	retryDelaySeconds := ScaledDecimal fromString: (retryInfo at: 'retryDelay') allButLast.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatGenerator >> prepareRequestJSONObject [

	(requestJSONObject := EsOrderedDictionary new)
		add: 'contents' -> (Array streamContents: [ :stream |
			chat userMessages do: [ :userMessage |
				stream nextPut: userMessage userContentJSON.
				userMessage generatedContents do: [ :generatedContent |
					stream nextPut: generatedContent modelContentJSON.
					generatedContent userContentJSON ifNotNil: [ :userContentJSON |
						stream nextPut: userContentJSON ] ] ] ]);
		add: 'tools' -> (EsOrderedDictionary with: 'functionDeclarations' -> functionsSet functionDeclarationsJSON);
		add: 'systemInstruction' -> (EsOrderedDictionary with: 'parts' -> { EsOrderedDictionary with: 'text' -> chat systemInstruction });
		add: 'generationConfig' -> (EsOrderedDictionary with: 'thinkingConfig' -> (EsOrderedDictionary with: 'includeThoughts' -> true))
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> requestCredentials [

	^ nil
]

{ #category : 'Not categorized' }
GeminiChatGenerator >> requestHeaders [

	^ EsOrderedDictionary with: 'x-goog-api-key' -> GeminiChat apiKey
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiChatGenerator >> url [

	^ SstUrl fromString: ('https://generativelanguage.googleapis.com/v1beta/models/%1:streamGenerateContent' bindWith: generationModel name)
]
