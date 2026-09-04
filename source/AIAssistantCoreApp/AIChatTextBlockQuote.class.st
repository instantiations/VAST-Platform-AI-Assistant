Class {
	#name : 'AIChatTextBlockQuote',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'sequenceBlock'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextBlockQuote class >> new [

	^ self basicNew initialize
]

{ #category : 'Instantiation' }
AIChatTextBlockQuote class >> startingAtLine: line [

	line ifEmpty: [ ^ nil ].
	line first = $> ifFalse: [ ^ nil ].
	(line size = 1 or: [ line second = Character space ]) ifFalse: [ ^ nil ].
	^ self new
]

{ #category : 'Comparing' }
AIChatTextBlockQuote >> = object [

	^ self class = object class and: [ self sequenceBlock = object sequenceBlock ]
]

{ #category : 'Accessing' }
AIChatTextBlockQuote >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Initialization' }
AIChatTextBlockQuote >> initialize [

	super initialize.
	sequenceBlock := AIChatTextBlockSequence new.
]

{ #category : 'Testing' }
AIChatTextBlockQuote >> isQuoteBlock [

	^ true
]

{ #category : 'Parsing' }
AIChatTextBlockQuote >> lineWithoutStartMarker: line [

	^ line copyFrom: 3 to: line size
]

{ #category : 'Parsing' }
AIChatTextBlockQuote >> matchLine: line [

	^ (line notEmpty and: [ line first = $> and: [ line size = 1 or: [ line second = Character space ] ] ]) ifTrue: [
		line copyFrom: 3 to: line size ]
]

{ #category : 'Accessing' }
AIChatTextBlockQuote >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Accessing' }
AIChatTextBlockQuote >> textElement [

	self shouldNotImplement
]
