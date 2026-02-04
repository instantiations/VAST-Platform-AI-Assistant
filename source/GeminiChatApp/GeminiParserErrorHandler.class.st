Class {
	#name : 'GeminiParserErrorHandler',
	#superclass : 'Object',
	#instVars : [
		'block'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiParserErrorHandler class >> block: block [

	^ self basicNew initializeWith: block
]

{ #category : 'Not categorized' }
GeminiParserErrorHandler >> initializeWith: initialBlock [

	self initialize.
	block := initialBlock
]

{ #category : 'Not categorized' }
GeminiParserErrorHandler >> parseError: error sourcePosition: sourcePosition [

	^ block value: error value: sourcePosition
]
