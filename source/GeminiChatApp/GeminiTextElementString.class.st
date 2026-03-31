Class {
	#name : 'GeminiTextElementString',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'textString'
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
GeminiTextElementString >> = object [

	^ self class = object class and: [ self string = object string ]
]

{ #category : 'Not categorized' }
GeminiTextElementString >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementString: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementString >> initializeWithString: initialString [

	self initialize.
	textString := GeminiTextString string: initialString.
]

{ #category : 'Not categorized' }
GeminiTextElementString >> isStringElement [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextElementString >> resetLayout [

	self textString resetLayout
]

{ #category : 'Not categorized' }
GeminiTextElementString >> string [

	^ textString string
]

{ #category : 'Not categorized' }
GeminiTextElementString >> string: newString [

	textString := GeminiTextString string: newString
]

{ #category : 'Not categorized' }
GeminiTextElementString >> textString [

	^ textString
]
