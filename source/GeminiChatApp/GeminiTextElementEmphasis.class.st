Class {
	#name : 'GeminiTextElementEmphasis',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'isStrong',
		'element'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextElementEmphasis class >> isStrong: isStrong element: element [

	^ self basicNew initializeWithIsStrong: isStrong element: element
]

{ #category : 'Not categorized' }
GeminiTextElementEmphasis >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextElementEmphasis: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementEmphasis >> element [

	^ element
]

{ #category : 'Not categorized' }
GeminiTextElementEmphasis >> initializeWithIsStrong: initialIsStrong element: initialElement [

	self initialize.
	isStrong := initialIsStrong.
	element := initialElement.
]

{ #category : 'Not categorized' }
GeminiTextElementEmphasis >> isEmphasisElement [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextElementEmphasis >> isStrong [

	^ isStrong
]
