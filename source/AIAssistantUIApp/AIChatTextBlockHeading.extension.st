Extension {
	#name : 'AIChatTextBlockHeading'
}

{ #category : 'Drawing' }
AIChatTextBlockHeading >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockHeading: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextBlockHeading >> spacingFactorAfter [

	^ 2 / 3
]

{ #category : 'Drawing' }
AIChatTextBlockHeading >> spacingFactorBefore [

	^ 1
]

{ #category : 'Writing' }
AIChatTextBlockHeading >> writeFormattedOn: stream [

	level timesRepeat: [
		stream nextPut: $# ].
	stream space.
	text writeFormattedOn: stream.
	stream newLine.
]
