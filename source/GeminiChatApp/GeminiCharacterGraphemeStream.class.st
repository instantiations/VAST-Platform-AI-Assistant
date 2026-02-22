Class {
	#name : 'GeminiCharacterGraphemeStream',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiCharacterGraphemeStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
GeminiCharacterGraphemeStream >> atEnd [

	^ stream atEnd
]

{ #category : 'Not categorized' }
GeminiCharacterGraphemeStream >> collectionSpecies [

	^ String
]

{ #category : 'Not categorized' }
GeminiCharacterGraphemeStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
]

{ #category : 'Not categorized' }
GeminiCharacterGraphemeStream >> next [

	^ self atEnd ifFalse: [
		| value |
		value := stream next value.
		value <= 127
			ifTrue: [ Character codePoint: value ]
			ifFalse: [ Grapheme codePoint: value ] ]
]
