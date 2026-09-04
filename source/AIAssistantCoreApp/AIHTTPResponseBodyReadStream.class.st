Class {
	#name : 'AIHTTPResponseBodyReadStream',
	#superclass : 'AIAbstractHTTPResponseBodyReadStream',
	#instVars : [
		'contentLength',
		'position'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIHTTPResponseBodyReadStream class >> on: socketStream contentLength: contentLength [

	^ self basicNew initializeWithSocketStream: socketStream contentLength: contentLength
]

{ #category : 'Reading' }
AIHTTPResponseBodyReadStream >> atEnd [

	^ position = contentLength
]

{ #category : 'Initialization' }
AIHTTPResponseBodyReadStream >> initializeWithSocketStream: initialSocketStream contentLength: initialContentLength [

	self initializeWithSocketStream: initialSocketStream.
	contentLength := initialContentLength.
	position := 0.
]

{ #category : 'Reading' }
AIHTTPResponseBodyReadStream >> next [

	self atEnd ifTrue: [ ^ nil ].
	position := position + 1.
	^ socketStream next
]
