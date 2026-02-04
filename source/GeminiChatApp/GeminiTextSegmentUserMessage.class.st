Class {
	#name : 'GeminiTextSegmentUserMessage',
	#superclass : 'GeminiAbstractTextSegment',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextSegmentUserMessage class >> textBlocks: textBlocks [

	^ self basicNew initializeWithTextBlocks: textBlocks
]

{ #category : 'Not categorized' }
GeminiTextSegmentUserMessage >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentUserMessage: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentUserMessage >> isTextSegmentUserMessage [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextSegmentUserMessage >> textColor [

	^ Color black
]
