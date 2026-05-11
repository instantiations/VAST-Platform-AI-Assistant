Class {
	#name : 'AIChatTextSegmentError',
	#superclass : 'AIAbstractChatTextSegment',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentError class >> forError: error onRetry: retryBlock onInspect: inspectBlock onDebug: debugBlock [

	^ self basicNew initializeWithTextBlocks: {
		AIChatTextBlockText text: (AIChatTextElementString string: 'ERROR: ' , error description).
		AIChatTextBlockText text: (AIChatTextElementSequence elements: {
			AIChatTextElementAction element: (AIChatTextElementString string: 'Retry') block: retryBlock.
			AIChatTextElementString string: (String new: 2 withAll: Character space).
			AIChatTextElementAction element: (AIChatTextElementString string: 'Inspect') block: inspectBlock.
			AIChatTextElementString string: (String new: 2 withAll: Character space).
			AIChatTextElementAction element: (AIChatTextElementString string: 'Debug') block: debugBlock }) }
]
