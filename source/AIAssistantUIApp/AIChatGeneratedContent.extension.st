Extension {
	#name : 'AIChatGeneratedContent'
}

{ #category : 'Not categorized' }
AIChatGeneratedContent >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' modelContentParts: '.
	modelContentParts storeOn: stream.
	stream nextPutAll: ' functionResponseParts: '.
	functionResponseParts storeOn: stream.
	stream nextPut: $).
]
