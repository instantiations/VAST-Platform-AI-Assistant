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
