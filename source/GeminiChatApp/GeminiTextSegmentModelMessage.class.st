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
GeminiTextSegmentModelMessage >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentModelMessage: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentModelMessage >> textColor [

	^ Color black
]
