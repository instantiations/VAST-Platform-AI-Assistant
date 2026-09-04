Extension {
	#name : 'AIChatTextElementAction'
}

{ #category : 'Widget Event Handling' }
AIChatTextElementAction >> buttonPressedIn: chatWidget [

	actionBlock value
]

{ #category : 'Drawing' }
AIChatTextElementAction >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementAction: self dc: dc
]

{ #category : 'Widget Event Handling' }
AIChatTextElementAction >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Widget Event Handling' }
AIChatTextElementAction >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Drawing' }
AIChatTextElementAction >> resetLayout [

	self element resetLayout
]

{ #category : 'Writing' }
AIChatTextElementAction >> writeFormattedOn: stream [

	self shouldNotImplement
]
