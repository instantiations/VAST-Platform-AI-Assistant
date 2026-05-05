Extension {
	#name : 'AIChatGeneratedContentPartFunctionResponse'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' id: '.
	id storeOn: stream.
	stream nextPutAll: ' name: '.
	name storeOn: stream.
	stream nextPutAll: ' response: '.
	response storeOn: stream.
	stream nextPut: $).
]
