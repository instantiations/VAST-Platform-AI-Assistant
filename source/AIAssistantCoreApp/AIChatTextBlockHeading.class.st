Class {
	#name : 'AIChatTextBlockHeading',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'level',
		'text'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextBlockHeading class >> fromLine: line [

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
				^ self level: level text: (AIChatTextElementSequence fromString: (line copyFrom: index to: line size)) ] ] ].
	^ self level: level text: AIChatTextElementSequence new
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading class >> level: level text: text [

	^ self basicNew initializeWithLevel: level text: text
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> = object [

	^ self class = object class and: [ self level = object level and: [ self textElement = object textElement ] ]
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> initializeWithLevel: initialLevel text: initialText [

	self initialize.
	level := initialLevel.
	text := initialText.
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> isHeadingBlock [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> level [

	^ level
]

{ #category : 'Not categorized' }
AIChatTextBlockHeading >> textElement [

	^ text
]
