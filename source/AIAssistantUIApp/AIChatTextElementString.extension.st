Extension {
	#name : 'AIChatTextElementString'
}

{ #category : 'Not categorized' }
AIChatTextElementString >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementString: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextElementString >> resetLayout [

	self textString resetLayout
]
