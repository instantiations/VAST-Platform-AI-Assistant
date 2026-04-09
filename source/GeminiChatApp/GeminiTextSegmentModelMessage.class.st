Class {
	#name : 'GeminiTextSegmentModelMessage',
	#superclass : 'GeminiAbstractTextSegment',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextSegmentModelMessage class >> textBlocks: textBlocks [

	^ self basicNew initializeWithTextBlocks: textBlocks
]

{ #category : 'Not categorized' }
GeminiTextSegmentModelMessage >> copyStateFrom: oldMessage [
	"Transfer any state in old message that is not regenerated when creating new message with #modelText"
	oldMessage textBlocks doWithIndex: [ :oldTextBlock :index |
		(textBlocks at: index) copyStateFrom: oldTextBlock ]
]

{ #category : 'Not categorized' }
GeminiTextSegmentModelMessage >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentModelMessage: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentModelMessage >> textColor [

	^ Color black
]
