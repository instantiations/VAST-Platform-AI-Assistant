Class {
	#name : 'GeminiTextElementAction',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'element',
		'isPointedTo',
		'actionBlock'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextElementAction class >> element: element block: block [

	^ self basicNew initializeWithElement: element  block: block
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> = object [

	^ self class = object class and: [ self element = object element ]
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> buttonPressedIn: chatWidget [

	actionBlock value
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementAction: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> element [

	^ element
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> initializeWithElement: anElement block: block [

	element :=anElement.
	actionBlock := block.
	isPointedTo := false.
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementAction >> resetLayout [

	self element resetLayout
]
