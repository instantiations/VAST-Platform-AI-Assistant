Class {
	#name : 'GeminiTextSegmentError',
	#superclass : 'GeminiAbstractTextSegment',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextSegmentError class >> fromError: error [

	^ self basicNew initializeWithTextBlocks: { GeminiTextBlockText text: (GeminiTextElementString string: 'ERROR: ' , error description) }
]

{ #category : 'Not categorized' }
GeminiTextSegmentError >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentError: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentError >> textColor [

	^ Color red
]
