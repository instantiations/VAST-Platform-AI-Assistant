Class {
	#name : 'AICharacterGraphemeStream',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AICharacterGraphemeStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
AICharacterGraphemeStream >> atEnd [

	^ stream atEnd
]

{ #category : 'Not categorized' }
AICharacterGraphemeStream >> collectionSpecies [

	^ String
]

{ #category : 'Not categorized' }
AICharacterGraphemeStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
]

{ #category : 'Not categorized' }
AICharacterGraphemeStream >> next [

	^ self atEnd ifFalse: [
		| value |
		value := stream next value.
		value <= 127
			ifTrue: [ Character codePoint: value ]
			ifFalse: [ Grapheme codePoint: value ] ]
]
