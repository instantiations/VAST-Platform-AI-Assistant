Class {
	#name : 'GeminiTextBlockText',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'text'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockText class >> fromString: string [

	^ self text: (GeminiTextElementSequence fromString: string)
]

{ #category : 'Not categorized' }
GeminiTextBlockText class >> new [

	^ self text: GeminiTextElementString new
]

{ #category : 'Not categorized' }
GeminiTextBlockText class >> text: text [

	^ self basicNew initializeWithText: text
]

{ #category : 'Not categorized' }
GeminiTextBlockText >> = object [

	^ self class = object class and: [ self textElement = object textElement ]
]

{ #category : 'Not categorized' }
GeminiTextBlockText >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextBlockText: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextBlockText >> initializeWithText: initialText [

	self initialize.
	text := initialText.
]

{ #category : 'Not categorized' }
GeminiTextBlockText >> isTextBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockText >> textElement [

	^ text
]
