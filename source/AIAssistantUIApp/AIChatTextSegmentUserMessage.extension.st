Extension {
	#name : 'AIChatTextSegmentUserMessage'
}

{ #category : 'Not categorized' }
AIChatTextSegmentUserMessage >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentUserMessage: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextSegmentUserMessage >> textColor [

	^ Color black
]
