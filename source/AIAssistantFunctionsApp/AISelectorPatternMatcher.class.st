Class {
	#name : 'AISelectorPatternMatcher',
	#superclass : 'AIAbstractSelectorPatternMatcher',
	#instVars : [
		'pattern',
		'ignoreCase'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AISelectorPatternMatcher >> initializeWithPattern: initialPattern ignoreCase: initialIgnoreCase [

	self initialize.
	pattern := initialPattern.
	ignoreCase := initialIgnoreCase.
]

{ #category : 'Not categorized' }
AISelectorPatternMatcher >> matchesAnySendsInMethod: method [

	^ method symbolLiterals anySatisfy: [ :symbolLiteral | pattern match: symbolLiteral ignoreCase: ignoreCase ]
]

{ #category : 'Not categorized' }
AISelectorPatternMatcher >> matchingSelectorsInClass: class [

	^ class selectors select: [ :selector | pattern match: selector ignoreCase: ignoreCase ]
]
