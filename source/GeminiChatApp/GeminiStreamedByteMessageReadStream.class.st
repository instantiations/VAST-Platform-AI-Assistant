Class {
	#name : 'GeminiStreamedByteMessageReadStream',
	#superclass : 'Object',
	#instVars : [
		'streamedByteMessage',
		'chunksQueue',
		'chunkStream'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiStreamedByteMessageReadStream class >> on: streamedByteMessage [

	^ self basicNew initializeWithStreamedByteMessage: streamedByteMessage
]

{ #category : 'Not categorized' }
GeminiStreamedByteMessageReadStream >> atEnd [

	^ chunkStream isNil
]

{ #category : 'Not categorized' }
GeminiStreamedByteMessageReadStream >> checkStream [

	[ chunkStream atEnd ] whileTrue: [
		(chunkStream := chunksQueue remove ifNotNil: [ :chunk | chunk readStream ]) ifNil: [ ^ self ] ].
]

{ #category : 'Not categorized' }
GeminiStreamedByteMessageReadStream >> initializeWithStreamedByteMessage: initialStreamedByteMessage [

	self initialize.
	streamedByteMessage := initialStreamedByteMessage.
	chunksQueue := SstSharedQueue new.
	streamedByteMessage inputStream
		listen: [ :chunk | chunksQueue add: chunk asByteArray ]
		onDone: [ chunksQueue add: nil ].
	chunksQueue remove ifNotNil: [ :chunk |
		chunkStream := chunk readStream.
		self checkStream ].
]

{ #category : 'Not categorized' }
GeminiStreamedByteMessageReadStream >> next [

	| next |

	self atEnd ifTrue: [ ^ nil ].
	next := chunkStream next.
	self checkStream.
	^ next
]
