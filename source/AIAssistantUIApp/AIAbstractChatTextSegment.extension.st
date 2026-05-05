Extension {
	#name : 'AIAbstractChatTextSegment'
}

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> drawOnChatWidget: chatWidget dc: dc [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> resetHeight [

	height := nil
]

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> resetLayout [

	self resetHeight.
	self textBlocks do: [ :textBlock |
		textBlock resetLayout ]
]
