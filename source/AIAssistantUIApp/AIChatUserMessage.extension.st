Extension {
	#name : 'AIChatUserMessage'
}

{ #category : 'Not categorized' }
AIChatUserMessage >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' message: '.
	message storeOn: stream.
	stream nextPutAll: ' generatedContents: '.
	generatedContents storeOn: stream.
	stream nextPut: $).
]
