Extension {
	#name : 'AIChatTextBlockThought'
}

{ #category : 'Not categorized' }
AIChatTextBlockThought >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentLayout.
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockThought: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> resetLayout [

	self sequenceBlock resetLayout
]
