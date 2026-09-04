Extension {
	#name : 'AIChatTextBlockFunctionCalls'
}

{ #category : 'Widget Event Handling' }
AIChatTextBlockFunctionCalls >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentLayout.
]

{ #category : 'Drawing' }
AIChatTextBlockFunctionCalls >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockFunctionCalls: self dc: dc
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockFunctionCalls >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockFunctionCalls >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Drawing' }
AIChatTextBlockFunctionCalls >> resetLayout [

	"Nothing to do"
]

{ #category : 'Drawing' }
AIChatTextBlockFunctionCalls >> spacingFactorAfter [

	^ 2 / 3
]

{ #category : 'Drawing' }
AIChatTextBlockFunctionCalls >> spacingFactorBefore [

	^ 2 / 3
]

{ #category : 'Writing' }
AIChatTextBlockFunctionCalls >> writeFormattedOn: stream [

	self shouldNotImplement
]
