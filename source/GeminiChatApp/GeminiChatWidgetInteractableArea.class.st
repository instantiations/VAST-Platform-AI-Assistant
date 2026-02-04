Class {
	#name : 'GeminiChatWidgetInteractableArea',
	#superclass : 'Object',
	#instVars : [
		'rectangle',
		'handler'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea class >> rectangle: rectangle handler: handler [

	^ self basicNew initializeWithRectangle: rectangle handler: handler
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> buttonPressedIn: chatWidget [

	^ handler buttonPressedIn: chatWidget
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> containsPoint: point [

	^ rectangle containsPoint: point
]

{ #category : 'Not categorized' }
GeminiChatWidgetInteractableArea >> initializeWithRectangle: initialRectangle handler: initialHandler [

	self initialize.
	rectangle := initialRectangle.
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
