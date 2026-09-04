Class {
	#name : 'AIChatTextBlockHeading',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'level',
		'text'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
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

{ #category : 'Instantiation' }
AIChatTextBlockHeading class >> level: level text: text [

	^ self basicNew initializeWithLevel: level text: text
]

{ #category : 'Comparing' }
AIChatTextBlockHeading >> = object [

	^ self class = object class and: [ self level = object level and: [ self textElement = object textElement ] ]
]

{ #category : 'Initialization' }
AIChatTextBlockHeading >> initializeWithLevel: initialLevel text: initialText [

	self initialize.
	level := initialLevel.
	text := initialText.
]

{ #category : 'Testing' }
AIChatTextBlockHeading >> isHeadingBlock [

	^ true
]

{ #category : 'Accessing' }
AIChatTextBlockHeading >> level [

	^ level
]

{ #category : 'Accessing' }
AIChatTextBlockHeading >> textElement [

	^ text
]
