Extension {
	#name : 'AIChatTextBlockSequence'
}

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockSequence: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> resetLayout [

	self blocks do: [ :block | block resetLayout ]
]
