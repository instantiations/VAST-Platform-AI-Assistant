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

	responseObject at: 'error' ifPresent: [ :error |
		Error signal: ('Received error in generated contents stream (code: %1, status: %2): %3' bindWith: (error at: 'code' ifAbsent: [ nil ])
			with: (error at: 'status' ifAbsent: [ nil ]) with: (error at: 'message' ifAbsent: [ nil ])) ].

	responseObject at: 'usageMetadata' ifPresent: [ :usageMetadata |
		chat tokenUsage: (AIChatTokenUsage prompt: (usageMetadata at: 'promptTokenCount') total: (usageMetadata at: 'totalTokenCount')) ].

	firstCandidate := (responseObject at: 'candidates' ifAbsent: [ ^ #() ]) first.
	firstCandidateContent := firstCandidate at: 'content' ifAbsent: [
		Error signal: 'Model stopped, reason: ' , (firstCandidate at: 'finishReason') ].
	(firstCandidateContent at: 'role') = 'model' ifFalse: [ Error signal: 'Expected generated content to have the role "model"' ].
	^ (firstCandidateContent at: 'parts' ifAbsent: [ #() ] ) collect: [ :partJSON | AIAbstractChatGeneratedContentPart fromJSON: partJSON ]
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
		add: 'generationConfig' -> (EsOrderedDictionary with: 'thinkingConfig' -> (EsOrderedDictionary with: 'includeThoughts' -> true)).
	generationModel thinkingLevel ifNotNil: [ :thinkingLevel |
		((requestJSONObject at: 'generationConfig') at: 'thinkingConfig') add: 'thinkingLevel' -> thinkingLevel ].
]
