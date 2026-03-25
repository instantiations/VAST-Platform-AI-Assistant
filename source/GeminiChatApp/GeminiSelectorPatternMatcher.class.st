Class {
	#name : 'GeminiSelectorPatternMatcher',
	#superclass : 'GeminiAbstractSelectorPatternMatcher',
	#instVars : [
		'pattern',
		'ignoreCase'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiSelectorPatternMatcher >> initializeWithPattern: initialPattern ignoreCase: initialIgnoreCase [

	self initialize.
	pattern := initialPattern.
	ignoreCase := initialIgnoreCase.
]

{ #category : 'Not categorized' }
GeminiSelectorPatternMatcher >> matchesAnySendsInMethod: method [

	^ method symbolLiterals anySatisfy: [ :symbolLiteral | pattern match: symbolLiteral ignoreCase: ignoreCase ]
]

{ #category : 'Not categorized' }
GeminiSelectorPatternMatcher >> matchingSelectorsInClass: class [

	^ class selectors select: [ :selector | pattern match: selector ignoreCase: ignoreCase ]
]
