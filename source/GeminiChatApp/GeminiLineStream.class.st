Class {
	#name : 'GeminiLineStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'position'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiLineStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
GeminiLineStream >> atEnd [

	^ stream atEnd
]

{ #category : 'Not categorized' }
GeminiLineStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
	position := 0.
]

{ #category : 'Not categorized' }
GeminiLineStream >> next [

	^ stream atEnd
		ifTrue: [ nil ]
		ifFalse: [
			position := position + 1.
			stream nextLine ]
]

{ #category : 'Not categorized' }
GeminiLineStream >> position [

	^ position
]

{ #category : 'Not categorized' }
GeminiLineStream >> position: newPosition [

	newPosition >= position ifFalse: [
		Error signal: 'Cannot set position to an earlier one' ].
	newPosition - position timesRepeat: [
		self next ]
]
