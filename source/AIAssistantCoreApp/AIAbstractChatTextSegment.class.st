Class {
	#name : 'AIAbstractChatTextSegment',
	#superclass : 'Object',
	#instVars : [
		'textBlocks',
		'height'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> height [

	^ height
]

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> height: newHeight [

	height := newHeight
]

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> initializeWithTextBlocks: initialTextBlocks [

	self initialize.
	textBlocks := initialTextBlocks
]

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> isTextSegmentUserMessage [

	^ false
]

{ #category : 'Not categorized' }
AIAbstractChatTextSegment >> textBlocks [

	^ textBlocks
]
