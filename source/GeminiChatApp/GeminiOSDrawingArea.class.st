Class {
	#name : 'GeminiOSDrawingArea',
	#superclass : 'OSComposite',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiOSDrawingArea >> wmPaint: wParam with: lParam [

	self paintDo: [ :rect |
		self exposeOSRect: rect ].
	^ 1
]
