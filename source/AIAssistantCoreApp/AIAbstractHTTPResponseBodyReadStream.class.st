Class {
	#name : 'AIAbstractHTTPResponseBodyReadStream',
	#superclass : 'Object',
	#instVars : [
		'socketStream'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIAbstractHTTPResponseBodyReadStream class >> on: socketStream header: header [

	^ header isChunkedTransferEncoding
		ifTrue: [ AIHTTPResponseChunkedBodyReadStream on: socketStream ]
		ifFalse: [ AIHTTPResponseBodyReadStream on: socketStream contentLength: header contentLength ]
]

{ #category : 'Initialization' }
AIAbstractHTTPResponseBodyReadStream >> initializeWithSocketStream: initialSocketStream [

	self initialize.
	(socketStream := initialSocketStream)
		isBytes: true.
]
