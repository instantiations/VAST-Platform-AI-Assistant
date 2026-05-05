Class {
	#name : 'AIAbstractChatTextBlock',
	#superclass : 'Object',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractChatTextBlock >> copyStateFrom: anotherTextBlock [
	"Copy any state from another block into self"
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isCodeBlock [

	^ false
]

{ #category : 'Not categorized' }
AIAbstractChatTextBlock >> isFunctionCallsBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isFunctionResponseBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isHeadingBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isListItemBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isNumberedListItemBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isQuoteBlock [

	^ false
]

{ #category : 'Not categorized' }
AIAbstractChatTextBlock >> isSequenceBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isTextBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> isThoughtBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> textElement [

	self subclassResponsibility
]
