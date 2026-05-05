Extension {
	#name : 'AIChatTextElementAction'
}

{ #category : 'Not categorized' }
AIChatTextElementAction >> buttonPressedIn: chatWidget [

	actionBlock value
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementAction: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> resetLayout [

	self element resetLayout
]
