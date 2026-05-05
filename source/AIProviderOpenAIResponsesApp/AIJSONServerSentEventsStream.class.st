Class {
	#name : 'AIJSONServerSentEventsStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'current'
	],
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Not categorized' }
AIJSONServerSentEventsStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
AIJSONServerSentEventsStream >> atEnd [

	^ current isNil
]

{ #category : 'Not categorized' }
AIJSONServerSentEventsStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
	self readCurrent.
]

{ #category : 'Not categorized' }
AIJSONServerSentEventsStream >> next [

	^ current ifNotNil: [
		| next |
		next := current.
		self readCurrent.
		next ]
]

{ #category : 'Not categorized' }
AIJSONServerSentEventsStream >> readCurrent [

	current := stream atEnd ifFalse: [
		| data |
		data := stream next data.
		data ~= '[DONE]' ifTrue: [ NeoJSONReader fromString: data ] ]
]
