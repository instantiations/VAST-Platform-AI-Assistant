Extension {
	#name : 'CgDrawable'
}

{ #category : 'CG-API' }
CgDrawable >> createChatWidgetPixmap: width height: height depth: depth [

	| pixmap |

	server beginRequest.

	pixmap := AIChatWidgetPixmap screen: self screen.
	self display reportIfError:
		(pixmap
			compatibleWith: self
			width: width
			height: height
			depth: depth).

	server endRequest.
	^pixmap
]
