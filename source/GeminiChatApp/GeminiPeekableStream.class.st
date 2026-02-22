Class {
	#name : 'GeminiPeekableStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'atEnd',
		'current'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiPeekableStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
GeminiPeekableStream >> atEnd [

	^ atEnd
]

{ #category : 'Not categorized' }
GeminiPeekableStream >> collectionSpecies [

	^ stream collectionSpecies
]

{ #category : 'Not categorized' }
GeminiPeekableStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
	atEnd := false.
	self readCurrent.
]

{ #category : 'Not categorized' }
GeminiPeekableStream >> next [

	| next |

	next := current.
	self readCurrent.
	^ next
]

{ #category : 'Not categorized' }
GeminiPeekableStream >> peek [

	^ current
]

{ #category : 'Not categorized' }
GeminiPeekableStream >> peekFor: object [

	self atEnd ifTrue: [ ^ false ].
	^ self peek = object ifTrue: [ self next. true ] ifFalse: [ false ]
]

{ #category : 'Not categorized' }
GeminiPeekableStream >> readCurrent [

	current := stream atEnd
		ifFalse: [ stream next ]
		ifTrue: [ atEnd := true. nil ]
]
