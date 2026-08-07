Class {
	#name : 'AIChatTest',
	#superclass : 'TestCase',
	#instVars : [
		'server'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIChatTest class >> resources [

	^ super resources , { AIServerTestResource }
]

{ #category : 'Not categorized' }
AIChatTest class >> testModels [

	^{
		AIModelGoogleGeminiAPI
			name: 'testmodelGeminiAPI'
			label: 'Gemini Test Model'
			provider: (
				AIModelProviderTestGoogleGeminiAPI
					createNamed: 'Responses Test Provider'
					baseUrl: 'http://localhost:9988/?test=MockGeminiAPI').
		AIModelOpenAIResponsesAPI
			name: 'testmodelResponses'
			label: 'Responses Test Model'
			provider: (
				AIModelProviderOpenAIResponsesAPI
					createNamed: 'Responses Test Provider'
					baseUrl: 'http://localhost:9988/?test=MockResponsesAPI') } 
]

{ #category : 'Not categorized' }
AIChatTest >> responseObjectResponseCompleted [

	^ EsOrderedDictionary with: 'type' -> 'response.completed'
		with: 'response' -> (EsOrderedDictionary with: 'usage' -> (EsOrderedDictionary with: 'input_tokens' -> 0 with: 'total_tokens' -> 0))
]

{ #category : 'Not categorized' }
AIChatTest >> test [

	| helloString |

	helloString := UnicodeString escaped: 'Hello! \u{1F604}'.
	AIServerTestResource current responseObjectsGeminiAPI: {
		EsOrderedDictionary with: 'candidates' -> {
			EsOrderedDictionary with: 'content' ->
				(EsOrderedDictionary
					with: 'role' -> 'model'
					with: 'parts' -> {
						EsOrderedDictionary with: 'text' -> helloString }) } }.
	AIServerTestResource current responseObjectsResponsesAPI: {
		EsOrderedDictionary with: 'type' -> 'response.output_text.delta' with: 'item_id' -> 'msg_1' with: 'delta' -> helloString.
		self responseObjectResponseCompleted }.

	self class testModels do: [ :model |
		| chat |
		chat := AITestChat systemInstruction: 'You are an AI assistant' model: model.
		chat sendUserMessage: 'Hi!'.
		self waitForChatGeneration: chat.
		self assert: chat userMessages size equals: 1.
		self assert: chat userMessages first generatedContents size equals: 1.
		self assert: chat userMessages first generatedContents first modelContentParts size equals: 1.
		self assert: chat userMessages first generatedContents first modelContentParts first string equals: helloString ]
]

{ #category : 'Not categorized' }
AIChatTest >> testFunctionCall [

	| functionName functionArguments messageString |

	functionName := 'testfunction'.
	functionArguments := EsOrderedDictionary with: 'testparameter1' -> 'testargument1' with: 'testparameter2' -> 'testargument2'.
	messageString := 'I called the function'.
	AIServerTestResource current responseObjectsSequenceGeminiAPI: {
		{
			EsOrderedDictionary with: 'candidates' -> {
				EsOrderedDictionary with: 'content' ->
					(EsOrderedDictionary
						with: 'role' -> 'model'
						with: 'parts' -> {
							EsOrderedDictionary with: 'functionCall' -> (EsOrderedDictionary with: 'name' -> functionName with: 'args' -> functionArguments) }) } }.
		{
			EsOrderedDictionary with: 'candidates' -> {
				EsOrderedDictionary with: 'content' ->
					(EsOrderedDictionary
						with: 'role' -> 'model'
						with: 'parts' -> {
							EsOrderedDictionary with: 'text' -> messageString }) } } }.
	AIServerTestResource current responseObjectsSequenceResponsesAPI: {
		{
			EsOrderedDictionary with: 'type' -> 'response.output_item.done'
				with: 'item' -> (EsOrderedDictionary with: 'id' -> 'fc_1' with: 'type' -> 'function_call' with: 'call_id' -> 'call_1'
					with: 'name' -> functionName with: 'arguments' -> (NeoJSONWriter toString: functionArguments)).
			self responseObjectResponseCompleted }.
		{
			EsOrderedDictionary with: 'type' -> 'response.output_text.delta' with: 'item_id' -> 'msg_1' with: 'delta' -> messageString.
			self responseObjectResponseCompleted } }.

	self class testModels do: [ :model |
		| chat |
		chat := AITestChat systemInstruction: 'You are an AI assistant' model: model.
		chat sendUserMessage: 'Call a function'.
		self waitForChatGeneration: chat.
		self assert: chat userMessages size equals: 1.
		self assert: chat userMessages first generatedContents size equals: 2.
		self assert: chat userMessages first generatedContents first modelContentParts size equals: 1.
		self assert: chat userMessages first generatedContents first modelContentParts first name equals: functionName.
		self assert: chat userMessages first generatedContents first modelContentParts first arguments equals: functionArguments.
		self assert: chat userMessages first generatedContents second modelContentParts size equals: 1.
		self assert: chat userMessages first generatedContents second modelContentParts first string equals: messageString ].
]

{ #category : 'Not categorized' }
AIChatTest >> waitForChatGeneration: chat [

	10 timesRepeat: [
		chat isGenerating ifFalse: [
			chat terminateGeneration.
			^ self ].
		(Delay forMilliseconds: 100) wait.
		[ CwAppContext default readAndDispatch ] whileTrue ].
	chat terminateGeneration.
	Error signal: 'Timed out while waiting for chat generation'
]
