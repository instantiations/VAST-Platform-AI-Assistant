Extension {
	#name : 'AIChat'
}

{ #category : 'Actions' }
AIChat >> resetTextSegmentLayout [

	self textSegments do: [ :textSegment | textSegment resetLayout ]
]

{ #category : 'Actions' }
AIChat >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' systemInstruction: '.
	systemInstruction storeOn: stream.
	stream nextPutAll: ' model: ('.
	AIAbstractModel storeOn: stream.
	stream nextPutAll: ' labeled: '.
	model label storeOn: stream.
	stream nextPutAll: ') filePaths: ('.
	(filePaths collect: [ :filePath | filePath originalName ]) storeOn: stream.
	stream nextPutAll: ' collect: [ :name | CfsPath named: name ])'.
	stream nextPutAll: ' userMessages: '.
	userMessages storeOn: stream.
	stream nextPut: $).
]
