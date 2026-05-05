Extension {
	#name : 'AIChatTextBlockHeading'
}

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockHeading: self dc: dc
]
