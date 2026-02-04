Class {
	#name : 'GeminiTextSegmentDelay',
	#superclass : 'GeminiAbstractTextSegment',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextSegmentDelay class >> forSeconds: seconds [

	^ self basicNew initializeWithTextBlocks: { GeminiTextBlockText text: (GeminiTextElementString string:
		('Exceeded Gemini API rate limit, waiting for %1 %2 ...' bindWith: seconds with: (seconds = 1 ifTrue: [ 'second' ] ifFalse: [ 'seconds' ]))) }
]

{ #category : 'Not categorized' }
GeminiTextSegmentDelay >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentDelay: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentDelay >> textColor [

	^ Color gray
]
