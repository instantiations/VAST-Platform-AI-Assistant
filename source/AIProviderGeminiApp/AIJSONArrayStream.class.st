Class {
	#name : 'AIJSONArrayStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'jsonReader',
		'current'
	],
	#category : 'AIProviderGeminiApp'
}

{ #category : 'Not categorized' }
AIJSONArrayStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
AIJSONArrayStream >> atEnd [

	^ current isNil
]

{ #category : 'Not categorized' }
AIJSONArrayStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
	(jsonReader := NeoJSONReader on: stream)
		mapClass: EsOrderedDictionary.
	jsonReader consumeWhitespace.
	(jsonReader matchChar: $[) ifFalse: [ Error signal: 'Stream did not begin with opening bracket' ].
	(jsonReader matchChar: $]) ifTrue: [
		stream atEnd ifFalse: [ Error signal: 'Stream did not end after closing bracket' ].
	] ifFalse: [
		current := jsonReader parseMap ]
]

{ #category : 'Not categorized' }
AIJSONArrayStream >> next [

	^ current ifNotNil: [ :next |
		(jsonReader matchChar: $,) ifTrue: [
			current := jsonReader parseValue.
		] ifFalse: [
			((jsonReader matchChar: $]) and: [ stream atEnd ]) ifFalse: [
				Error signal: 'Stream did not end with closing bracket' ].
			current := nil ].
		next ]
]
