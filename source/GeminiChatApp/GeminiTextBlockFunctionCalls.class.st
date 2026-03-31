Class {
	#name : 'GeminiTextBlockFunctionCalls',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'functionCalls',
		'isPointedTo',
		'isExpanded'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> addFunctionCall: functionCallContentPart [

	functionCalls add: functionCallContentPart
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentLayout.
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> copyStateFrom: anotherFunctionBlock [
	"Copy any state from another block into self"
	isExpanded := anotherFunctionBlock isExpanded.
	isPointedTo := anotherFunctionBlock isPointedTo.
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockFunctionCalls: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> functionCalls [

	^ functionCalls
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> initialize [

	super initialize.
	functionCalls := OrderedCollection new.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> isExpanded [

	^ isExpanded
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> isFunctionCallsBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> resetLayout [

	"Nothing to do"
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> textElement [

	self shouldNotImplement
]

{ #category : 'Not categorized' }
GeminiTextBlockFunctionCalls >> toggleIsExpanded [

	isExpanded := isExpanded not
]
