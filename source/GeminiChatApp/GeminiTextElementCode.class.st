Class {
	#name : 'GeminiTextElementCode',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'code',
		'isPointedTo'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextElementCode class >> code: code [

	^ self basicNew initializeWithCode: code
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> = object [

	^ self class = object class and: [ self code = object code ]
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> buttonPressedIn: chatWidget [

	self referencedClass ifNotNil: [ :referencedClass |
		referencedClass browse ]
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> code [

	^ code
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementCode: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> initializeWithCode: initialCode [

	self initialize.
	code := initialCode.
	isPointedTo := false.
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> isCodeElement [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> referencedClass [

	^ (code notEmpty and: [ code first isUppercase and: [ code isSmalltalkIdentifier ] ])
		ifTrue: [ Smalltalk classAt: code asEsString ]
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> referencesClass [

	^ self referencedClass notNil
]
