Class {
	#name : 'AILineStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'position'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AILineStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
AILineStream >> atEnd [

	^ stream atEnd
]

{ #category : 'Not categorized' }
AILineStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
	position := 0.
]

{ #category : 'Not categorized' }
AILineStream >> next [

	^ stream atEnd
		ifTrue: [ nil ]
		ifFalse: [
			position := position + 1.
			stream nextLine ]
]

{ #category : 'Not categorized' }
AILineStream >> position [

	^ position
]

{ #category : 'Not categorized' }
AILineStream >> position: newPosition [

	newPosition >= position ifFalse: [
		Error signal: 'Cannot set position to an earlier one' ].
	newPosition - position timesRepeat: [
		self next ]
]
