Class {
	#name : 'AIChatGeneratorGoogleGeminiAPITest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIChatGeneratorGoogleGeminiAPITest >> testPrepareRequestJSONObjectThinkingLevel [

	| model chat generator thinkingConfig |

	model := AIModelGoogleGeminiAPI
		name: 'gemini-2.5-flash'
		label: 'Gemini 2.5 Flash'
		provider: (AIModelProviderTestGoogleGeminiAPI createNamed: 'Gemini').

	chat := AITestChat systemInstruction: 'You are an AI assistant' model: model.
	chat sendUserMessage: 'Hello'.
	generator := AIChatGeneratorGoogleGeminiAPI forChat: chat.

	"Default thinking level"
	generator prepareRequestJSONObject.
	thinkingConfig := (generator requestJSONObject at: 'generationConfig') at: 'thinkingConfig'.
	self assert: (thinkingConfig at: 'includeThoughts') equals: true.
	self assert: (thinkingConfig includesKey: 'thinkingLevel') not.

	"Explicit thinking level"
	model thinkingLevel: 'high'.
	generator prepareRequestJSONObject.
	thinkingConfig := (generator requestJSONObject at: 'generationConfig') at: 'thinkingConfig'.
	self assert: (thinkingConfig at: 'includeThoughts') equals: true.
	self assert: (thinkingConfig at: 'thinkingLevel') equals: 'high'.

	"Reset to default"
	model thinkingLevel: 'default'.
	generator prepareRequestJSONObject.
	thinkingConfig := (generator requestJSONObject at: 'generationConfig') at: 'thinkingConfig'.
	self assert: (thinkingConfig at: 'includeThoughts') equals: true.
	self assert: (thinkingConfig includesKey: 'thinkingLevel') not.
]
