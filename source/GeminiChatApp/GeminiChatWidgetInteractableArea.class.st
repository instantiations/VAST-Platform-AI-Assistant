Class {
	#name : 'GeminiChatWidgetInteractableArea',
	#superclass : 'Object',
	#instVars : [
		'rectangles',
		'handler'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea class >> rectangle: rectangle handler: handler [

	^ self rectangles: { rectangle } handler: handler
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea class >> rectangles: rectangles handler: handler [

	^ self basicNew initializeWithRectangles: rectangles handler: handler
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> buttonPressedIn: chatWidget [

	^ handler buttonPressedIn: chatWidget
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> containsPoint: point [

	^ rectangles anySatisfy: [ :rectangle | rectangle containsPoint: point ]
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> initializeWithRectangles: initialRectangles handler: initialHandler [

	self initialize.
	rectangles := initialRectangles.
	handler := initialHandler.
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> pointerEnteredIn: chatWidget [

	handler pointerEnteredIn: chatWidget
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> pointerLeftIn: chatWidget [

	handler pointerLeftIn: chatWidget
]
