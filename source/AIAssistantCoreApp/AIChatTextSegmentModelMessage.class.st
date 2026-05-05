Class {
	#name : 'AIChatTextSegmentModelMessage',
	#superclass : 'AIAbstractChatTextSegment',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentModelMessage class >> textBlocks: textBlocks [

	^ self basicNew initializeWithTextBlocks: textBlocks
]

{ #category : 'Not categorized' }
AIChatTextSegmentModelMessage >> copyStateFrom: oldMessage [
	"Transfer any state in old message that is not regenerated when creating new message with #modelText"
	oldMessage textBlocks doWithIndex: [ :oldTextBlock :index |
		(textBlocks at: index) copyStateFrom: oldTextBlock ]
]
