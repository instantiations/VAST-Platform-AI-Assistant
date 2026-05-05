Class {
	#name : 'AIChatTokenUsage',
	#superclass : 'Object',
	#instVars : [
		'promptTokens',
		'totalTokens'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instance Creation' }
AIChatTokenUsage class >> prompt: promptTokens total: totalTokens [
	^self new initializePrompt: promptTokens total: totalTokens
]

{ #category : 'Initialization' }
AIChatTokenUsage >> initializePrompt: amountPrompt total: amountTotal [
	promptTokens := amountPrompt.
	totalTokens := amountTotal
	
]

{ #category : 'Initialization' }
AIChatTokenUsage >> printString [
	^'Tokens used (Prompt: %1 Total: %2)' bindWith: (promptTokens ifNil: ['-']) with:  (totalTokens ifNil: ['-'])
	
]
