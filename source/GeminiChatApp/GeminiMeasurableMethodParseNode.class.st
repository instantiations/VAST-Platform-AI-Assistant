Class {
	#name : 'GeminiMeasurableMethodParseNode',
	#superclass : 'Object',
	#instVars : [
		'methodParseNode'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiMeasurableMethodParseNode class >> methodParseNode: methodParseNode [

	^ self basicNew initializeWithMethodParseNode: methodParseNode
]

{ #category : 'Not categorized' }
GeminiMeasurableMethodParseNode >> ctSymbolLiterals [

	^ methodParseNode messagesSent
]

{ #category : 'Not categorized' }
GeminiMeasurableMethodParseNode >> initializeWithMethodParseNode: initialMethodParseNode [

	self initialize.
	methodParseNode := initialMethodParseNode.
]

{ #category : 'Not categorized' }
GeminiMeasurableMethodParseNode >> isLoaded [

	^ true
]
