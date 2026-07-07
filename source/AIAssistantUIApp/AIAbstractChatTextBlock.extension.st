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

{ #category : 'Not categorized' }
AIAbstractChatTextBlock >> spacingFactorAfter [

	^ 1 / 2
]

{ #category : 'Not categorized' }
AIAbstractChatTextBlock >> spacingFactorBefore [

	^ 1 / 2
]
