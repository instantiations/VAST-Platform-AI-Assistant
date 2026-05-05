Class {
	#name : 'AIChatTextBlockQuote',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'sequenceBlock'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextBlockQuote class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote class >> startingAtLine: line [

	line ifEmpty: [ ^ nil ].
	line first = $> ifFalse: [ ^ nil ].
	(line size = 1 or: [ line second = Character space ]) ifFalse: [ ^ nil ].
	^ self new
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> = object [

	^ self class = object class and: [ self sequenceBlock = object sequenceBlock ]
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> initialize [

	super initialize.
	sequenceBlock := AIChatTextBlockSequence new.
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> isQuoteBlock [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> lineWithoutStartMarker: line [

	^ line copyFrom: 3 to: line size
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> matchLine: line [

	^ (line notEmpty and: [ line first = $> and: [ line size = 1 or: [ line second = Character space ] ] ]) ifTrue: [
		line copyFrom: 3 to: line size ]
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Not categorized' }
AIChatTextBlockQuote >> textElement [

	self shouldNotImplement
]
