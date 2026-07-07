Extension {
	#name : 'AIChatTextSegmentModelCodeChanges'
}

{ #category : 'Not categorized' }
AIChatTextSegmentModelCodeChanges >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentModelCodeChanges: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextSegmentModelCodeChanges >> textColor [

	^ Color black
]
