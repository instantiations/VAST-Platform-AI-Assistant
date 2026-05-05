Class {
	#name : 'AIChatGeneratorGoogleGeminiAPI',
	#superclass : 'AIAbstractChatGenerator',
	#category : 'AIProviderGeminiApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorGoogleGeminiAPI >> addGeneratedContentParts: contentParts [

	chat userMessages last addModelContentPartsToLastGeneratedContent: contentParts
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorGoogleGeminiAPI >> jsonResponseStreamOn: characterStream [

	^ AIJSONArrayStream on: characterStream
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorGoogleGeminiAPI >> parseErrorResponseMessage: responseJSON [

	^ responseJSON first at: 'error'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorGoogleGeminiAPI >> parseResponse: responseObject [

	| firstCandidate firstCandidateContent |

	(responseObject includesKey: 'usageMetadata')
		ifTrue: [|metadata|
			metadata := responseObject at: 'usageMetadata'.
			chat tokenUsage: (AIChatTokenUsage prompt: (metadata at: 'promptTokenCount') total:  (metadata at: 'totalTokenCount'))].
	firstCandidate := (responseObject at: 'candidates' ifAbsent: [^self]) first.
	firstCandidateContent := firstCandidate at: 'content' ifAbsent: [nil].
	firstCandidateContent
		ifNil: [Error signal: 'Model stopped, reason: ' , (firstCandidate at: 'finishReason')].
	(firstCandidateContent at: 'role') = 'model'
		ifFalse: [Error signal: 'Expected generated content to have the role "model"'].
	^(firstCandidateContent at: 'parts' ifAbsent: [#()])
		collect: [:partJSON | AIAbstractChatGeneratedContentPart fromJSON: partJSON]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorGoogleGeminiAPI >> parseRetryDelaySecondsFrom: responseErrorObject [

	| details retryInfo |

	details := responseErrorObject at: 'details' ifAbsent: [ ^ self ].
	retryInfo := details detect: [ :detail | (detail at: '@type') = 'type.googleapis.com/google.rpc.RetryInfo' ] ifNone: [ ^ self ].
	retryDelaySeconds := ScaledDecimal fromString: (retryInfo at: 'retryDelay') allButLast.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorGoogleGeminiAPI >> prepareRequestJSONObject [

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
