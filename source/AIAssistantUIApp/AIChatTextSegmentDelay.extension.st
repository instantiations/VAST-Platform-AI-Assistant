Extension {
	#name : 'AIChatTextSegmentDelay'
}

{ #category : 'Not categorized' }
AIChatTextSegmentDelay >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentDelay: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextSegmentDelay >> textColor [

	^ Color gray
]
