Class {
	#name : 'GeminiTextBlockQuote',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'sequenceBlock'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockQuote class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote class >> startingAtLine: line [

	line ifEmpty: [ ^ nil ].
	line first = $> ifFalse: [ ^ nil ].
	(line size = 1 or: [ line second = Character space ]) ifFalse: [ ^ nil ].
	^ self new
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> = object [

	^ self class = object class and: [ self sequenceBlock = object sequenceBlock ]
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockQuote: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> initialize [

	super initialize.
	sequenceBlock := GeminiTextBlockSequence new.
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> isQuoteBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> lineWithoutStartMarker: line [

	^ line copyFrom: 3 to: line size
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> matchLine: line [

	^ (line notEmpty and: [ line first = $> and: [ line size = 1 or: [ line second = Character space ] ] ]) ifTrue: [
		line copyFrom: 3 to: line size ]
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Not categorized' }
GeminiTextBlockQuote >> textElement [

	self shouldNotImplement
]
