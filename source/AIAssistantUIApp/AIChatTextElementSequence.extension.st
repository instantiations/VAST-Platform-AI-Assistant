Extension {
	#name : 'AIChatTextElementSequence'
}

{ #category : 'Not categorized' }
AIChatTextElementSequence >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementSequence: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextElementSequence >> resetLayout [

	self elements do: [ :element | element resetLayout ]
]
