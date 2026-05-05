Class {
	#name : 'AIChatGeneratorOpenAIResponsesAPI',
	#superclass : 'AIAbstractChatGenerator',
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorOpenAIResponsesAPI >> addGeneratedContentParts: contentParts [

	contentParts do: [ :contentPart |
		chat userMessages last mergeModelContentPartIntoLastGeneratedContent: contentPart ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorOpenAIResponsesAPI >> jsonResponseStreamOn: characterStream [

	^ AIJSONServerSentEventsStream on: (AIServerSentEventsStream on: characterStream)
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorOpenAIResponsesAPI >> parseErrorResponseMessage: responseJSON [

	^ responseJSON at: 'error'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorOpenAIResponsesAPI >> parseResponse: responseObject [

	| type |

	type := responseObject at: 'type'.
	type = 'response.completed' ifTrue: [
		| usage |
		usage := (responseObject at: 'response') at: 'usage'.
		chat tokenUsage: (AIChatTokenUsage prompt: (usage at: 'input_tokens') total:  (usage at: 'total_tokens')).
		^ #() ].

	type = 'response.output_text.delta' ifTrue: [
		^ { AIChatGeneratedContentPartText string: (responseObject at: 'delta') } ].
	(type = 'response.reasoning_summary_text.delta' or: [ type = 'response.reasoning_text.delta' ]) ifTrue: [
		^ { AIChatGeneratedContentPartText string: (responseObject at: 'delta') thought: true thoughtSignature: (responseObject at: 'item_id') } ].
	type = 'response.output_item.done' ifTrue: [
		| item |
		item := responseObject at: 'item'.
		(item at: 'type') = 'function_call' ifTrue: [
			| arguments |
			arguments := NeoJSONReader fromString: (item at: 'arguments').
			^ { AIChatGeneratedContentPartFunctionCall id: (item at: 'call_id') name: (item at: 'name') arguments: arguments thoughtSignature: nil } ] ].

	^ #()
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGeneratorOpenAIResponsesAPI >> prepareRequestJSONObject [

	| reasoning |

	(requestJSONObject := EsOrderedDictionary new)
		add: 'model' -> generationModel name;
		add: 'instructions' ->  chat systemInstruction;
		add: 'input' -> (Array streamContents: [ :stream |
			chat userMessages do: [ :userMessage |
				stream nextPut: (EsOrderedDictionary with: 'role' -> 'user' with: 'content' -> userMessage message).
				userMessage generatedContents do: [ :generatedContent |
					| pendingFunctionResponseParts |
					pendingFunctionResponseParts := OrderedCollection withAll: generatedContent functionResponseParts.
					generatedContent modelContentParts do: [ :modelContentPart |
						modelContentPart isText
							ifTrue: [
								stream nextPut: (modelContentPart isThought
									ifTrue: [ EsOrderedDictionary with: 'type' -> 'reasoning' with: 'id' -> modelContentPart thoughtSignature
										with: 'summary' -> {(EsOrderedDictionary with: 'type' -> 'summary_text' with: 'text' -> modelContentPart string)} ]
									ifFalse: [ EsOrderedDictionary with: 'role' -> 'assistant' with: 'content' -> modelContentPart string ]) ]
							ifFalse: [
								| functionResponsePart |
								functionResponsePart := pendingFunctionResponseParts removeFirst.
								stream nextPut: (EsOrderedDictionary with: 'type' -> 'function_call' with: 'call_id' -> modelContentPart id
									with: 'name' -> modelContentPart name with: 'arguments' -> (NeoJSONWriter toString: modelContentPart arguments)).
								stream nextPut: (EsOrderedDictionary with: 'type' -> 'function_call_output' with: 'call_id' -> functionResponsePart id
									with: 'output' -> (NeoJSONWriter toString: functionResponsePart response)) ] ] ] ] ]);
		add: 'stream' -> true;
		add: 'store' -> false;
		add: 'tools' -> (functionsSet functions collect: [ :function | function functionDeclarationJSON copy at: 'type' put: 'function'; yourself ]);
		add: 'tool_choice' -> 'auto';
		add: 'parallel_tool_calls' -> true.
	generationModel temperature ifNotNil: [ :temperature | requestJSONObject add: 'temperature' -> temperature ].
	generationModel top_p ifNotNil: [ :top_p | requestJSONObject add: 'top_p' -> top_p ].
	reasoning := EsOrderedDictionary new.
	generationModel reasoningEffort ifNotNil: [ :reasoningEffort |
		reasoning add: 'effort' -> reasoningEffort ].
	generationModel reasoningSummary ifNotNil: [ :reasoningSummary |
		reasoning add: 'summary' -> reasoningSummary ].
	reasoning ifNotEmpty: [
		requestJSONObject add: 'reasoning' -> reasoning ].
]
