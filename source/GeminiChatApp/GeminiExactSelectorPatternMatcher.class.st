Class {
	#name : 'GeminiExactSelectorPatternMatcher',
	#superclass : 'GeminiAbstractSelectorPatternMatcher',
	#instVars : [
		'selector'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiExactSelectorPatternMatcher >> initializeWithSelector: initialSelector [

	self initialize.
	selector := initialSelector.
]

{ #category : 'Not categorized' }
GeminiExactSelectorPatternMatcher >> matchesAnySendsInMethod: method [

	^ method sendsSelector: selector
]

{ #category : 'Not categorized' }
GeminiExactSelectorPatternMatcher >> matchingSelectorsInClass: class [

	^ (class includesSelector: selector) ifTrue: [ { selector } ] ifFalse: [ #() ]
]
