Class {
	#name : 'AIAbstractChatTextBlock',
	#superclass : 'Object',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Copying' }
AIAbstractChatTextBlock >> copyStateFrom: anotherTextBlock [
	"Copy any state from another block into self"
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isCodeBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isCodeChangesBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isFunctionCallsBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isFunctionResponseBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isHeadingBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isListItemBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isNumberedListItemBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isQuoteBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isSequenceBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isTextBlock [

	^ false
]

{ #category : 'Testing' }
AIAbstractChatTextBlock >> isThoughtBlock [

	^ false
]

{ #category : 'Accessing' }
AIAbstractChatTextBlock >> textElement [

	self subclassResponsibility
]
