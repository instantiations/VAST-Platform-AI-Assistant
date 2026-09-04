Extension {
	#name : 'AIAbstractChatTextBlock'
}

{ #category : 'Drawing' }
AIAbstractChatTextBlock >> drawOnChatWidget: chatWidget dc: dc [

	self subclassResponsibility
]

{ #category : 'Drawing' }
AIAbstractChatTextBlock >> resetLayout [

	self textElement resetLayout
]

{ #category : 'Drawing' }
AIAbstractChatTextBlock >> spacingFactorAfter [

	^ 1 / 2
]

{ #category : 'Drawing' }
AIAbstractChatTextBlock >> spacingFactorBefore [

	^ 1 / 2
]

{ #category : 'Writing' }
AIAbstractChatTextBlock >> writeFormattedOn: stream [

	self subclassResponsibility
]
