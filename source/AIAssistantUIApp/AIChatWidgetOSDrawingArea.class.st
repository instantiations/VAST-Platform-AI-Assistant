Class {
	#name : 'AIChatWidgetOSDrawingArea',
	#superclass : 'OSComposite',
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatWidgetOSDrawingArea >> extStyle [

	^ super extStyle bitOr: 16r02000000 "WS_EX_COMPOSITED"
]
