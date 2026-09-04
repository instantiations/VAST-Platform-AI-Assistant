Extension {
	#name : 'AIChatTextBlockSequence'
}

{ #category : 'Drawing' }
AIChatTextBlockSequence >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockSequence: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextBlockSequence >> resetLayout [

	self blocks do: [ :block | block resetLayout ]
]

{ #category : 'Drawing' }
AIChatTextBlockSequence >> spacingFactorAfter [

	^ self blocks ifEmpty: [ 0 ] ifNotEmpty: [ self blocks last spacingFactorAfter ]
]

{ #category : 'Drawing' }
AIChatTextBlockSequence >> spacingFactorBefore [

	^ self blocks ifEmpty: [ 0 ] ifNotEmpty: [ self blocks first spacingFactorBefore ]
]

{ #category : 'Writing' }
AIChatTextBlockSequence >> writeFormattedOn: stream [

	blocks do: [ :block | block writeFormattedOn: stream ] separatedBy: [ stream newLine ]
]
