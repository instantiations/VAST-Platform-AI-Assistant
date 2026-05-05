Class {
	#name : 'AIStreamedByteMessageReadStream',
	#superclass : 'Object',
	#instVars : [
		'streamedByteMessage',
		'chunksQueue',
		'chunkStream'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIStreamedByteMessageReadStream class >> on: streamedByteMessage [

	^ self basicNew initializeWithStreamedByteMessage: streamedByteMessage
]

{ #category : 'Not categorized' }
AIStreamedByteMessageReadStream >> atEnd [

	^ chunkStream isNil
]

{ #category : 'Not categorized' }
AIStreamedByteMessageReadStream >> checkStream [

	[ chunkStream atEnd ] whileTrue: [
		(chunkStream := chunksQueue remove ifNotNil: [ :chunk | chunk readStream ]) ifNil: [ ^ self ] ].
]

{ #category : 'Not categorized' }
AIStreamedByteMessageReadStream >> initializeWithStreamedByteMessage: initialStreamedByteMessage [

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
AIStreamedByteMessageReadStream >> next [

	| next |

	self atEnd ifTrue: [ ^ nil ].
	next := chunkStream next.
	self checkStream.
	^ next
]
