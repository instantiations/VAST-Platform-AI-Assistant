Extension {
	#name : 'AIChatTextBlockQuote'
}

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockQuote: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> resetLayout [

	self sequenceBlock resetLayout
]
