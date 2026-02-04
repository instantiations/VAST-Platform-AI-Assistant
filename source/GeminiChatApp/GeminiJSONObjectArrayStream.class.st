Class {
	#name : 'GeminiJSONObjectArrayStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'jsonReader',
		'current'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiJSONObjectArrayStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
GeminiJSONObjectArrayStream >> atEnd [

	^ current isNil
]

{ #category : 'Not categorized' }
GeminiJSONObjectArrayStream >> initializeWithStream: initialStream [

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
GeminiJSONObjectArrayStream >> next [

	^ current ifNotNil: [ :next |
		(jsonReader matchChar: $,) ifTrue: [
			current := jsonReader parseMap.
		] ifFalse: [
			((jsonReader matchChar: $]) and: [ stream atEnd ]) ifFalse: [
				Error signal: 'Stream did not end with closing bracket' ].
			current := nil ].
		next ]
]
