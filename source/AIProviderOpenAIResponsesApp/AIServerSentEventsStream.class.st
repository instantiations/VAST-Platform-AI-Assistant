Class {
	#name : 'AIServerSentEventsStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'lastEventID'
	],
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Not categorized' }
AIServerSentEventsStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> atEnd [

	^ stream atEnd
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> atEndOfLine [

	^ (stream peek = Character cr) or: [ stream peek = Character lf ]
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
	lastEventID := ''.
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> next [

	^ self atEnd ifFalse: [ self readEvent ]
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> readComment [

	^ String streamContents: [ :commentStream |
		[ self atEndOfLine ] whileFalse: [
			commentStream nextPut: stream next ].
		self readEndOfLine ]
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> readEndOfLine [

	(stream peekFor: Character cr) ifTrue: [
		stream peekFor: Character lf.
		^ self ].
	(stream peekFor: Character lf) ifTrue: [
		^ self ].
	Error signal: 'Expected end-of-line'
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> readEvent [

	| eventType data |

	eventType := ''.
	data := String streamContents: [ :dataStream |
		[ self atEndOfLine ] whileFalse: [
			(stream peekFor: $:) ifTrue: [
				self readComment
			] ifFalse: [
				| field |
				field := self readField.
				field key = 'event' ifTrue: [
					eventType := field value ].
				field key = 'data' ifTrue: [
					dataStream position = 0 ifFalse: [
						dataStream nextPut: Character lf ].
					dataStream nextPutAll: field value ].
				field key = 'id' ifTrue: [
					(field value includes: (Character codePoint: 0)) ifFalse: [
						lastEventID := field value ] ] ] ].
		self readEndOfLine ].
	^ AIServerSentEvent type: (eventType ifEmpty: [ 'message' ]) data: data lastEventID: lastEventID
]

{ #category : 'Not categorized' }
AIServerSentEventsStream >> readField [

	| fieldName fieldValue |

	fieldName := String streamContents: [ :fieldNameStream |
		[ self atEndOfLine or: [ stream peekFor: $: ] ] whileFalse: [
			fieldNameStream nextPut: stream next ] ].
	stream peekFor: Character space.
	fieldValue := String streamContents: [ :fieldValueStream |
		[ self atEndOfLine ] whileFalse: [
			fieldValueStream nextPut: stream next ] ].
	self readEndOfLine.
	^ fieldName -> fieldValue
]
