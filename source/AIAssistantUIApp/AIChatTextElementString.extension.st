Extension {
	#name : 'AIChatTextElementString'
}

{ #category : 'Drawing' }
AIChatTextElementString >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementString: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextElementString >> resetLayout [

	self textString resetLayout
]

{ #category : 'Writing' }
AIChatTextElementString >> writeFormattedOn: stream [

	self string do: [ :character |
		(#($\ $[ $] $` $* $( $)) includes: character) ifTrue: [
			stream nextPut: $\ ].
		stream nextPut: character ]
]
