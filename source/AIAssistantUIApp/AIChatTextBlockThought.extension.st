Extension {
	#name : 'AIChatTextBlockThought'
}

{ #category : 'Widget Event Handling' }
AIChatTextBlockThought >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentLayout.
]

{ #category : 'Drawing' }
AIChatTextBlockThought >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockThought: self dc: dc
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockThought >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockThought >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Drawing' }
AIChatTextBlockThought >> resetLayout [

	self sequenceBlock resetLayout
]

{ #category : 'Drawing' }
AIChatTextBlockThought >> spacingFactorAfter [

	^ 2 / 3
]

{ #category : 'Drawing' }
AIChatTextBlockThought >> spacingFactorBefore [

	^ 2 / 3
]

{ #category : 'Writing' }
AIChatTextBlockThought >> writeFormattedOn: stream [

	self shouldNotImplement
]
