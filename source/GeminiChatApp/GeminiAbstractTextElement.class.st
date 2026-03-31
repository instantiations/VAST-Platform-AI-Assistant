Class {
	#name : 'GeminiAbstractTextElement',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractTextElement >> drawOnChatWidget: chatWidget dc: dc [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractTextElement >> isEmphasisElement [

	^ false
]

{ #category : 'Not categorized' }
GeminiAbstractTextElement >> isSequenceElement [

	^ false
]

{ #category : 'Not categorized' }
GeminiAbstractTextElement >> isStringElement [

	^ false
]

{ #category : 'Not categorized' }
GeminiAbstractTextElement >> resetLayout [

	self subclassResponsibility
]
