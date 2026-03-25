Class {
	#name : 'GeminiAbstractSelectorPatternMatcher',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractSelectorPatternMatcher class >> forPattern: pattern ignoreCase: ignoreCase [

	^ (ignoreCase or: [ (pattern includes: $*) or: [ pattern includes: $# ] ])
		ifTrue: [ GeminiSelectorPatternMatcher basicNew initializeWithPattern: pattern ignoreCase: ignoreCase ]
		ifFalse: [ GeminiExactSelectorPatternMatcher basicNew initializeWithSelector: pattern asSymbol ]
]

{ #category : 'Not categorized' }
GeminiAbstractSelectorPatternMatcher >> matchesAnySendsInMethod: method [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractSelectorPatternMatcher >> matchingSelectorsInClass: class [

	self subclassResponsibility
]
