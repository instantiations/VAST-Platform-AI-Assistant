Extension {
	#name : 'AIChatTextElementLink'
}

{ #category : 'Widget Event Handling' }
AIChatTextElementLink >> buttonPressedIn: chatWidget [

	AbtWebInfo openWebBrowserOn: destination
]

{ #category : 'Drawing' }
AIChatTextElementLink >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementLink: self dc: dc
]

{ #category : 'Testing' }
AIChatTextElementLink >> hasBrowsableDestination [

	| url |

	(url := SstUrl fromString: destination) ifNil: [ ^ false ].
	^ #('http' 'https') includes: url scheme
]

{ #category : 'Widget Event Handling' }
AIChatTextElementLink >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Widget Event Handling' }
AIChatTextElementLink >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Drawing' }
AIChatTextElementLink >> resetLayout [

	self element resetLayout
]

{ #category : 'Writing' }
AIChatTextElementLink >> writeFormattedOn: stream [

	stream nextPut: $[.
	element writeFormattedOn: stream.
	stream nextPut: $]; nextPut: $(.
	destination do: [ :character |
		(#($\ $( $)) includes: character) ifTrue: [
			stream nextPut: $\ ].
		stream nextPut: character ].
	stream nextPut: $).
]
