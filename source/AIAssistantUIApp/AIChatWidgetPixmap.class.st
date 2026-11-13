Class {
	#name : 'AIChatWidgetPixmap',
	#superclass : 'CgPixmap',
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetPixmap >> autoScaleContext [

	^ AIChatWidgetPixmapAutoScaleContext instance
]

{ #category : 'Not categorized' }
AIChatWidgetPixmap >> isAutoScalable [

	^ true
]
