Class {
	#name : 'GeminiFontSet',
	#superclass : 'Object',
	#instVars : [
		'proportional',
		'monospaced'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFontSet class >> proportional: proportional monospaced: monospaced [

	^ self basicNew initializeWithProportional: proportional monospaced: monospaced
]

{ #category : 'Not categorized' }
GeminiFontSet class >> size: fontSize [

	^ self proportional: (GeminiFontStyles size: fontSize monospaced: false)
		monospaced: (GeminiFontStyles size: fontSize monospaced: true)
]

{ #category : 'Not categorized' }
GeminiFontSet >> freeFonts [

	proportional freeFonts.
	monospaced freeFonts.
]

{ #category : 'Not categorized' }
GeminiFontSet >> initializeWithProportional: initialProportional monospaced: initialMonospaced [

	self initialize.
	proportional := initialProportional.
	monospaced := initialMonospaced.
]

{ #category : 'Not categorized' }
GeminiFontSet >> monospaced [

	^ monospaced
]

{ #category : 'Not categorized' }
GeminiFontSet >> proportional [

	^ proportional
]
