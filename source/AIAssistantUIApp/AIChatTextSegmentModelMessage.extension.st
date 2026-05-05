Extension {
	#name : 'AIChatTextSegmentModelMessage'
}

{ #category : 'Not categorized' }
AIChatTextSegmentModelMessage >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentModelMessage: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextSegmentModelMessage >> textColor [

	^ Color black
]
