Class {
	#name : 'AIAbstractSelectorPatternMatcher',
	#superclass : 'Object',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIAbstractSelectorPatternMatcher class >> forPattern: pattern ignoreCase: ignoreCase [

	^ (ignoreCase or: [ (pattern includes: $*) or: [ pattern includes: $# ] ])
		ifTrue: [ AISelectorPatternMatcher basicNew initializeWithPattern: pattern ignoreCase: ignoreCase ]
		ifFalse: [ AIExactSelectorPatternMatcher basicNew initializeWithSelector: pattern asSymbol ]
]

{ #category : 'Not categorized' }
AIAbstractSelectorPatternMatcher >> matchesAnySendsInMethod: method [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractSelectorPatternMatcher >> matchingSelectorsInClass: class [

	self subclassResponsibility
]
