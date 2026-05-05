Extension {
	#name : 'AIChatTextSegmentSystemInstruction'
}

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentLayout.
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentSystemInstruction: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> textColor [

	^ Color darkGray
]
