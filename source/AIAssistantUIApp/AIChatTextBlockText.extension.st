Extension {
	#name : 'AIChatTextBlockText'
}

{ #category : 'Not categorized' }
AIChatTextBlockText >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextBlockText: self dc: dc
]
