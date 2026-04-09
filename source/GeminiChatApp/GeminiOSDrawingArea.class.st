Class {
	#name : 'GeminiOSDrawingArea',
	#superclass : 'OSComposite',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiOSDrawingArea >> extStyle [

	^ super extStyle bitOr: 16r02000000 "WS_EX_COMPOSITED"
]
