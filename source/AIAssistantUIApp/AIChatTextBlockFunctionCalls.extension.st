Extension {
	#name : 'AIChatTextBlockFunctionCalls'
}

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentLayout.
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockFunctionCalls: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> resetLayout [

	"Nothing to do"
]
