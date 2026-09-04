Class {
	#name : 'AIModelGoogleGeminiAPITest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIModelGoogleGeminiAPITest >> testThinkingLevel [

	| model anotherModel |

	model := AIModelGoogleGeminiAPI
		name: 'gemini-2.5-flash'
		label: 'Gemini 2.5 Flash'
		provider: (AIModelProviderTestGoogleGeminiAPI createNamed: 'Gemini').

	self assert: model thinkingLevel isNil.

	model thinkingLevel: 'low'.
	self assert: model thinkingLevel equals: 'low'.
	model thinkingLevel: 'high'.
	self assert: model thinkingLevel equals: 'high'.
	model thinkingLevel: 'minimal'.
	self assert: model thinkingLevel equals: 'minimal'.
	model thinkingLevel: 'medium'.
	self assert: model thinkingLevel equals: 'medium'.
	model thinkingLevel: 'default'.
	self assert: model thinkingLevel isNil.

	model thinkingLevel: 'unknown'.
	self assert: model thinkingLevel isNil.
	model thinkingLevel: 'high'.
	model thinkingLevel: ''.
	self assert: model thinkingLevel isNil.

	model thinkingLevel: 'high'.
	anotherModel := AIModelGoogleGeminiAPI
		name: 'gemini-2.5-flash-copy'
		label: 'Gemini 2.5 Flash Copy'
		provider: (AIModelProviderTestGoogleGeminiAPI createNamed: 'Gemini').
	anotherModel copyStateFrom: model.
	self assert: anotherModel thinkingLevel equals: 'high'.

	self assert: (model sameAs: anotherModel) not.
	anotherModel := AIModelGoogleGeminiAPI
		name: 'gemini-2.5-flash'
		label: 'Gemini 2.5 Flash'
		provider: (AIModelProviderTestGoogleGeminiAPI createNamed: 'Gemini').
	anotherModel thinkingLevel: 'high'.
	self assert: (model sameAs: anotherModel).
	anotherModel thinkingLevel: 'low'.
	self assert: (model sameAs: anotherModel) not.
]
