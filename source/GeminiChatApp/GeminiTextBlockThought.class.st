Class {
	#name : 'GeminiTextBlockThought',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'sequenceBlock',
		'isPointedTo',
		'isExpanded'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockThought class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentHeights.
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockThought: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> initialize [

	super initialize.
	sequenceBlock := GeminiTextBlockSequence new.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> isExpanded [

	^ isExpanded
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> isThoughtBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> lastTopicLine [

	^ sequenceBlock lastTopicLine
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> textElement [

	self shouldNotImplement
]

{ #category : 'Not categorized' }
GeminiTextBlockThought >> toggleIsExpanded [

	isExpanded := isExpanded not
]
