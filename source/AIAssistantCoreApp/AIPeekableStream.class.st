Class {
	#name : 'AIPeekableStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'atEnd',
		'current'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIPeekableStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
AIPeekableStream >> atEnd [

	^ atEnd
]

{ #category : 'Not categorized' }
AIPeekableStream >> collectionSpecies [

	^ stream collectionSpecies
]

{ #category : 'Not categorized' }
AIPeekableStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
	atEnd := false.
	self readCurrent.
]

{ #category : 'Not categorized' }
AIPeekableStream >> next [

	| next |

	next := current.
	self readCurrent.
	^ next
]

{ #category : 'Not categorized' }
AIPeekableStream >> peek [

	^ current
]

{ #category : 'Not categorized' }
AIPeekableStream >> peekFor: object [

	self atEnd ifTrue: [ ^ false ].
	^ self peek = object ifTrue: [ self next. true ] ifFalse: [ false ]
]

{ #category : 'Not categorized' }
AIPeekableStream >> readCurrent [

	current := stream atEnd
		ifFalse: [ stream next ]
		ifTrue: [ atEnd := true. nil ]
]
