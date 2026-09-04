Extension {
	#name : 'AIChatTextElementSequence'
}

{ #category : 'Drawing' }
AIChatTextElementSequence >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementSequence: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextElementSequence >> resetLayout [

	self elements do: [ :element | element resetLayout ]
]

{ #category : 'Writing' }
AIChatTextElementSequence >> writeFormattedOn: stream [

	elements do: [ :element | element writeFormattedOn: stream ]
]
