Class {
	#name : 'AIChatWidgetFontSet',
	#superclass : 'Object',
	#instVars : [
		'proportional',
		'monospaced'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetFontSet class >> proportional: proportional monospaced: monospaced [

	^ self basicNew initializeWithProportional: proportional monospaced: monospaced
]

{ #category : 'Not categorized' }
AIChatWidgetFontSet class >> size: fontSize [

	^ self proportional: (AIChatWidgetFontStyles size: fontSize monospaced: false)
		monospaced: (AIChatWidgetFontStyles size: fontSize monospaced: true)
]

{ #category : 'Not categorized' }
AIChatWidgetFontSet >> freeFonts [

	proportional freeFonts.
	monospaced freeFonts.
]

{ #category : 'Not categorized' }
AIChatWidgetFontSet >> initializeWithProportional: initialProportional monospaced: initialMonospaced [

	self initialize.
	proportional := initialProportional.
	monospaced := initialMonospaced.
]

{ #category : 'Not categorized' }
AIChatWidgetFontSet >> monospaced [

	^ monospaced
]

{ #category : 'Not categorized' }
AIChatWidgetFontSet >> proportional [

	^ proportional
]
