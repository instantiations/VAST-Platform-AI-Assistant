Class {
	#name : 'AIChatWidgetPixmapAutoScaleContext',
	#superclass : 'Object',
	#classVars : [
		'Instance'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetPixmapAutoScaleContext class >> instance [

	^ Instance ifNil: [ Instance := self new ]
]

{ #category : 'Not categorized' }
AIChatWidgetPixmapAutoScaleContext >> getDpiForWindow [

	^ DPIScaler instance class dpiZoom100
]

{ #category : 'Not categorized' }
AIChatWidgetPixmapAutoScaleContext >> isNull [

	^ false
]
