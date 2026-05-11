Extension {
	#name : 'AIChatTextBlockHeading'
}

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockHeading: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> spacingFactorAfter [

	^ 2 / 3
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> spacingFactorBefore [

	^ 1
]
