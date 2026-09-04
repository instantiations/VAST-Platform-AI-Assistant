Class {
	#name : 'AIHTTPResponseChunkedBodyReadStream',
	#superclass : 'AIAbstractHTTPResponseBodyReadStream',
	#instVars : [
		'chunkSize',
		'chunkByteCount'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIHTTPResponseChunkedBodyReadStream class >> on: socketStream [

	^ self basicNew initializeWithSocketStream: socketStream
]

{ #category : 'Reading' }
AIHTTPResponseChunkedBodyReadStream >> atEnd [

	^ chunkSize = 0
]

{ #category : 'Initialization' }
AIHTTPResponseChunkedBodyReadStream >> initializeWithSocketStream: initialSocketStream [

	super initializeWithSocketStream: initialSocketStream.
	self readChunkStart.
]

{ #category : 'Reading' }
AIHTTPResponseChunkedBodyReadStream >> next [

	| next |

	self atEnd ifTrue: [ ^ nil ].
	next := socketStream next.
	(chunkByteCount := chunkByteCount + 1) = chunkSize ifTrue: [
		(socketStream next = Character cr value and: [ socketStream next = Character lf value ]) ifFalse: [
			Error signal: 'Invalid chunk' ].
		self readChunkStart ].
	^ next
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIHTTPResponseChunkedBodyReadStream >> readChunkStart [

	chunkSize := 0.
	[
		| digitValue |
		((digitValue := (Character value: socketStream next) digitValue) between: 0 and: 15) ifFalse: [
			Error signal: 'Invalid chunk size' ].
		chunkSize := chunkSize * 16 + digitValue.
		socketStream peek = $; value or: [ socketStream peek = Character cr value ]
	] whileFalse.

	socketStream next = $; value ifTrue: [
		[ socketStream next = Character cr value ] whileFalse ].
	socketStream next = Character lf value ifFalse: [
		Error signal: 'Invalid chunk' ].

	chunkByteCount := 0.
]
