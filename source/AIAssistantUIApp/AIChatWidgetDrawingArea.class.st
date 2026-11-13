Class {
	#name : 'AIChatWidgetDrawingArea',
	#superclass : 'CwDrawingArea',
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetDrawingArea >> autoScaleChanged [

	super autoScaleChanged.
	self parent extendedWidget drawingAreaAutoScaleChanged.
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingArea >> osWidgetClass [

	^ AIChatWidgetOSDrawingArea
]
