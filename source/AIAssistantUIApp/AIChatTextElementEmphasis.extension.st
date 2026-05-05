Extension {
	#name : 'AIChatTextElementEmphasis'
}

{ #category : 'Not categorized' }
AIChatTextElementEmphasis >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementEmphasis: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextElementEmphasis >> resetLayout [

	self element resetLayout
]
