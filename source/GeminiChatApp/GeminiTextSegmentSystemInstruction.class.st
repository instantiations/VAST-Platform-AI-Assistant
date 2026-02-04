Class {
	#name : 'GeminiTextSegmentSystemInstruction',
	#superclass : 'GeminiAbstractTextSegment',
	#instVars : [
		'isPointedTo',
		'isExpanded'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction class >> forSystemInstruction: systemInstruction [

	^ self basicNew initializeWithTextBlocks: { GeminiTextBlockSequence fromString: systemInstruction }
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> buttonPressedIn: chatWidget [

	self toggleIsExpanded.
	chatWidget resetTextSegmentHeights.
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentSystemInstruction: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> initialize [

	super initialize.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> isExpanded [

	^ isExpanded
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> textColor [

	^ Color darkGray
]

{ #category : 'Not categorized' }
GeminiTextSegmentSystemInstruction >> toggleIsExpanded [

	isExpanded := isExpanded not
]
