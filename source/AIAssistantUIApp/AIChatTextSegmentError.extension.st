Extension {
	#name : 'AIChatTextSegmentError'
}

{ #category : 'Not categorized' }
AIChatTextSegmentError >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentError: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextSegmentError >> textColor [

	^ Color red
]
