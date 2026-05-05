Class {
	#name : 'AIChatWidgetInteractableArea',
	#superclass : 'Object',
	#instVars : [
		'rectangles',
		'handler'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetInteractableArea class >> rectangle: rectangle handler: handler [

	^ self rectangles: { rectangle } handler: handler
]

{ #category : 'Not categorized' }
AIChatWidgetInteractableArea class >> rectangles: rectangles handler: handler [

	^ self basicNew initializeWithRectangles: rectangles handler: handler
]

{ #category : 'Not categorized' }
AIChatWidgetInteractableArea >> buttonPressedIn: chatWidget [

	^ handler buttonPressedIn: chatWidget
]

{ #category : 'Not categorized' }
AIChatWidgetInteractableArea >> containsPoint: point [

	^ rectangles anySatisfy: [ :rectangle | rectangle containsPoint: point ]
]

{ #category : 'Not categorized' }
AIChatWidgetInteractableArea >> initializeWithRectangles: initialRectangles handler: initialHandler [

	self initialize.
	rectangles := initialRectangles.
	handler := initialHandler.
]

{ #category : 'Not categorized' }
AIChatWidgetInteractableArea >> pointerEnteredIn: chatWidget [

	handler pointerEnteredIn: chatWidget
]

{ #category : 'Not categorized' }
AIChatWidgetInteractableArea >> pointerLeftIn: chatWidget [

	handler pointerLeftIn: chatWidget
]
