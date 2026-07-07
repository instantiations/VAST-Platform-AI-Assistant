Class {
	#name : 'AIChatTextSegmentModelCodeChanges',
	#superclass : 'AIAbstractChatTextSegment',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentModelCodeChanges class >> changes: codeChanges [

	^ self basicNew initializeWithTextBlocks: { AIChatTextBlockCodeChanges changes: codeChanges }
]
