Extension {
	#name : 'UnicodeString'
}

{ #category : 'Not categorized' }
UnicodeString >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' escaped: '.
	self escaped asSBString storeOn: stream.
	stream nextPut: $).
]

{ #category : 'Not categorized' }
UnicodeString >> storeOn: stream recursionSet: objectsAlreadySeen [

	self storeOn: stream
]
