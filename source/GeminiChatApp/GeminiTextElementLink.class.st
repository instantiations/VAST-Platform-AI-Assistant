Class {
	#name : 'GeminiTextElementLink',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'element',
		'destination',
		'isPointedTo'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextElementLink class >> element: element destination: destination [

	^ self basicNew initializeWithElement: element destination: destination
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> = object [

	^ self class = object class and: [ self element = object element and: [ self destination = object destination ] ]
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> buttonPressedIn: chatWidget [

	AbtWebInfo openWebBrowserOn: destination
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> destination [

	^ destination
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementLink: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> element [

	^ element
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> hasBrowsableDestination [

	| url |

	(url := SstUrl fromString: destination) ifNil: [ ^ false ].
	^ #('http' 'https') includes: url scheme
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> initializeWithElement: initialElement destination: initialDestination [

	self initialize.
	element := initialElement.
	destination := initialDestination.
	isPointedTo := false.
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementLink >> resetLayout [

	self element resetLayout
]
