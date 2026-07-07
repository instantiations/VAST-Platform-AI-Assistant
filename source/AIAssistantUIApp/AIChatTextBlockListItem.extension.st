Extension {
	#name : 'AIChatTextBlockListItem'
}

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockListItem: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> resetLayout [

	self sequenceBlock resetLayout
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> spacingFactorAfter [

	^ 1 / 10
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> spacingFactorBefore [

	^ 1 / 10
]
