Class {
	#name : 'AIChatTextSegmentSystemInstruction',
	#superclass : 'AIAbstractChatTextSegment',
	#instVars : [
		'isPointedTo',
		'isExpanded'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction class >> forSystemInstruction: systemInstruction [

	^ self basicNew initializeWithTextBlocks: { AIChatTextBlockSequence fromString: systemInstruction }
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> initialize [

	super initialize.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> isExpanded [

	^ isExpanded
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
AIChatTextSegmentSystemInstruction >> toggleIsExpanded [

	isExpanded := isExpanded not
]
