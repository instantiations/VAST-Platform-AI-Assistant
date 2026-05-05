Extension {
	#name : 'AIChatTextElementLink'
}

{ #category : 'Not categorized' }
AIChatTextElementLink >> buttonPressedIn: chatWidget [

	AbtWebInfo openWebBrowserOn: destination
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementLink: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> hasBrowsableDestination [

	| url |

	(url := SstUrl fromString: destination) ifNil: [ ^ false ].
	^ #('http' 'https') includes: url scheme
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> resetLayout [

	self element resetLayout
]
