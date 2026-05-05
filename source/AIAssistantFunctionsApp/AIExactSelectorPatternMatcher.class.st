Class {
	#name : 'AIExactSelectorPatternMatcher',
	#superclass : 'AIAbstractSelectorPatternMatcher',
	#instVars : [
		'selector'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIExactSelectorPatternMatcher >> initializeWithSelector: initialSelector [

	self initialize.
	selector := initialSelector.
]

{ #category : 'Not categorized' }
AIExactSelectorPatternMatcher >> matchesAnySendsInMethod: method [

	^ method sendsSelector: selector
]

{ #category : 'Not categorized' }
AIExactSelectorPatternMatcher >> matchingSelectorsInClass: class [

	^ (class includesSelector: selector) ifTrue: [ { selector } ] ifFalse: [ #() ]
]
