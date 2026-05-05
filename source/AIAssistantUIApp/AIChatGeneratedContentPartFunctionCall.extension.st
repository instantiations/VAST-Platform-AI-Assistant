Extension {
	#name : 'AIChatGeneratedContentPartFunctionCall'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' id: '.
	id storeOn: stream.
	stream nextPutAll: ' name: '.
	name storeOn: stream.
	stream nextPutAll: ' arguments: '.
	arguments storeOn: stream.
	stream nextPutAll: ' thoughtSignature: '.
	thoughtSignature storeOn: stream.
	stream nextPut: $).
]
