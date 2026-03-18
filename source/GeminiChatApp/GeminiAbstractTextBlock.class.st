Class {
	#name : 'GeminiAbstractTextBlock',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractTextBlock >> copyStateFrom: anotherTextBlock [
	"Copy any state from another block into self"
]

{ #category : 'Not categorized' }
GeminiAbstractTextBlock >> drawOnChatWidget: chatWidget dc: dc [

	self subclassResponsibility
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isCodeBlock [

	^ false
]

{ #category : 'Not categorized' }
GeminiAbstractTextBlock >> isFunctionCallsBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isFunctionResponseBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isHeadingBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isListItemBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isNumberedListItemBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isQuoteBlock [

	^ false
]

{ #category : 'Not categorized' }
GeminiAbstractTextBlock >> isSequenceBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isTextBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> isThoughtBlock [

	^ false
]

{ #category : 'Accessing' }
GeminiAbstractTextBlock >> textElement [

	self subclassResponsibility
]
