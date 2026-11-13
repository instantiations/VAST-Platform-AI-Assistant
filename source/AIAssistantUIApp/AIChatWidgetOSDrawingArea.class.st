Class {
	#name : 'AIChatWidgetOSDrawingArea',
	#superclass : 'OSComposite',
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatWidgetOSDrawingArea >> exposeOSRect: aRect [

	| scale |

	scale := DPIScaler getDeviceScaleFactor: self autoScaleContext.
	super exposeOSRect: (Rectangle left: aRect left right: (aRect right / scale) ceiling * scale
		top: aRect top bottom: (aRect bottom / scale) ceiling * scale)
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatWidgetOSDrawingArea >> extStyle [

	^ super extStyle bitOr: 16r02000000 "WS_EX_COMPOSITED"
]
