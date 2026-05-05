Extension {
	#name : 'AIAbstractChatTextBlock'
}

{ #category : 'Not categorized' }
AIAbstractChatTextBlock >> drawOnChatWidget: chatWidget dc: dc [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractChatTextBlock >> resetLayout [

	self textElement resetLayout
]
