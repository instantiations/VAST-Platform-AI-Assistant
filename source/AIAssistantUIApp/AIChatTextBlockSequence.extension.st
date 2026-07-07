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

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> spacingFactorAfter [

	^ self blocks ifEmpty: [ 0 ] ifNotEmpty: [ self blocks last spacingFactorAfter ]
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> spacingFactorBefore [

	^ self blocks ifEmpty: [ 0 ] ifNotEmpty: [ self blocks first spacingFactorBefore ]
]
