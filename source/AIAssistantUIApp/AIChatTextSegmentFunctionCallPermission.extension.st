Extension {
	#name : 'AIChatTextSegmentFunctionCallPermission'
}

{ #category : 'Not categorized' }
AIChatTextSegmentFunctionCallPermission >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentFunctionCallPermission: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextSegmentFunctionCallPermission >> textColor [

	^ Color black
]
