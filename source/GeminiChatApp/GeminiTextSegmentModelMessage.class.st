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
GeminiTextSegmentModelMessage >> copyStateFrom: anOldMessage [
	"Transfer any state in old message that is not regenerated when creating new message with #modelText"
	self textBlocks doWithIndex: [:block :index |
			 anOldMessage textBlocks size >= index
				ifTrue: [
				block copyStateFrom: (anOldMessage textBlocks at: index)]	]
]

{ #category : 'Not categorized' }
GeminiTextSegmentModelMessage >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentModelMessage: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentModelMessage >> textColor [

	^ Color black
]
