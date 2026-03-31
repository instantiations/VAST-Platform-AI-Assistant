Class {
	#name : 'GeminiAbstractTextSegment',
	#superclass : 'Object',
	#instVars : [
		'textBlocks',
		'height'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> drawOnChatWidget: chatWidget dc: dc [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> height [

	^ height
]

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> height: newHeight [

	height := newHeight
]

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> initializeWithTextBlocks: initialTextBlocks [

	self initialize.
	textBlocks := initialTextBlocks
]

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> isTextSegmentUserMessage [

	^ false
]

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> resetHeight [

	height := nil
]

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> resetLayout [

	self resetHeight.
	self textBlocks do: [ :textBlock |
		textBlock resetLayout ]
]

{ #category : 'Not categorized' }
GeminiAbstractTextSegment >> textBlocks [

	^ textBlocks
]
