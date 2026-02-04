Class {
	#name : 'GeminiTextElementString',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'string'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextElementString class >> new [

	^ self string: ''
]

{ #category : 'Not categorized' }
GeminiTextElementString class >> string: string [

	^ self basicNew initializeWithString: string
]

{ #category : 'Not categorized' }
GeminiTextElementString >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextElementString: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementString >> initializeWithString: initialString [

	self initialize.
	string := initialString.
]

{ #category : 'Not categorized' }
GeminiTextElementString >> isStringElement [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextElementString >> string [

	^ string
]

{ #category : 'Not categorized' }
GeminiTextElementString >> string: newString [

	string := newString
]
