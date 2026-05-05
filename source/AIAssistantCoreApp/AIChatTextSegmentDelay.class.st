Class {
	#name : 'AIChatTextSegmentDelay',
	#superclass : 'AIAbstractChatTextSegment',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentDelay class >> forSeconds: seconds [

	^ self basicNew initializeWithTextBlocks: { AIChatTextBlockText text: (AIChatTextElementString string:
		('Exceeded API rate limit, waiting for %1 %2 ...' bindWith: seconds with: (seconds = 1 ifTrue: [ 'second' ] ifFalse: [ 'seconds' ]))) }
]
