Extension {
	#name : 'AIAbstractChatTextElement'
}

{ #category : 'Drawing' }
AIAbstractChatTextElement >> drawOnChatWidget: chatWidget dc: dc [

	self subclassResponsibility
]

{ #category : 'Drawing' }
AIAbstractChatTextElement >> resetLayout [

	self subclassResponsibility
]

{ #category : 'Writing' }
AIAbstractChatTextElement >> writeFormattedOn: stream [

	self subclassResponsibility
]
