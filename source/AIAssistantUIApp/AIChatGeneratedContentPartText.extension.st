Extension {
	#name : 'AIChatGeneratedContentPartText'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' string: '.
	string storeOn: stream.
	stream nextPutAll: ' thought: '.
	thought storeOn: stream.
	stream nextPutAll: ' thoughtSignature: '.
	thoughtSignature storeOn: stream.
	stream nextPut: $).
]
