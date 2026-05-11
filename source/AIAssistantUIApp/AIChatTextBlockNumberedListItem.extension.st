Extension {
	#name : 'AIChatTextBlockNumberedListItem'
}

{ #category : 'Not categorized' }
AIChatTextBlockNumberedListItem >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockNumberedListItem: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextBlockNumberedListItem >> resetLayout [

	self sequenceBlock resetLayout
]

{ #category : 'Not categorized' }
AIChatTextBlockNumberedListItem >> spacingFactorAfter [

	^ 1 / 10
]

{ #category : 'Not categorized' }
AIChatTextBlockNumberedListItem >> spacingFactorBefore [

	^ 1 / 10
]
