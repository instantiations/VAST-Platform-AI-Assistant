Class {
	#name : 'AIChatTextSegmentUserMessage',
	#superclass : 'AIAbstractChatTextSegment',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentUserMessage class >> textBlocks: textBlocks [

	^ self basicNew initializeWithTextBlocks: textBlocks
]

{ #category : 'Not categorized' }
AIChatTextSegmentUserMessage >> isTextSegmentUserMessage [

	^ true
]
