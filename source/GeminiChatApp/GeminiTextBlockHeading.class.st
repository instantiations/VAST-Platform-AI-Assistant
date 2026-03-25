Class {
	#name : 'GeminiTextBlockHeading',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'level',
		'text'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockHeading class >> fromLine: line [

	| level afterLevel |

	level := 0.
	afterLevel := false.
	line keysAndValuesDo: [ :index :character |
		afterLevel ifFalse: [
			character = $# ifTrue: [
				level := level + 1
			] ifFalse: [
				afterLevel := true ] ].
		afterLevel ifTrue: [
			character isSeparator ifFalse: [
				^ self level: level text: (GeminiTextElementSequence fromString: (line copyFrom: index to: line size)) ] ] ].
	^ self level: level text: GeminiTextElementSequence new
]

{ #category : 'Not categorized' }
GeminiTextBlockHeading class >> level: level text: text [

	^ self basicNew initializeWithLevel: level text: text
]

{ #category : 'Not categorized' }
GeminiTextBlockHeading >> = object [

	^ self class = object class and: [ self level = object level and: [ self textElement = object textElement ] ]
]

{ #category : 'Not categorized' }
GeminiTextBlockHeading >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockHeading: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextBlockHeading >> initializeWithLevel: initialLevel text: initialText [

	self initialize.
	level := initialLevel.
	text := initialText.
]

{ #category : 'Not categorized' }
GeminiTextBlockHeading >> isHeadingBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockHeading >> level [

	^ level
]

{ #category : 'Not categorized' }
GeminiTextBlockHeading >> textElement [

	^ text
]
