Class {
	#name : 'GeminiTokenUsage',
	#superclass : 'Object',
	#instVars : [
		'promptTokens',
		'totalTokens'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Instance Creation' }
GeminiTokenUsage class >> prompt: promptTokens total: totalTokens [
	^self new initializePrompt: promptTokens total: totalTokens
]

{ #category : 'Initialization' }
GeminiTokenUsage >> initializePrompt: amountPrompt total: amountTotal [
	promptTokens := amountPrompt.
	totalTokens := amountTotal
	
]

{ #category : 'Initialization' }
GeminiTokenUsage >> printString [
	^'Tokens used (Prompt: %1 Total: %2)' bindWith: (promptTokens ifNil: ['-']) with:  (totalTokens ifNil: ['-'])
	
]
