Class {
	#name : 'AISubstringRegexMatcher',
	#superclass : 'AIAbstractRegexMatcher',
	#instVars : [
		'ignoreCase',
		'regex'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AISubstringRegexMatcher >> initializeWithRegex: initialRegex ignoreCase: initialIgnoreCase [

	self initialize.
	regex := initialRegex.
	ignoreCase := initialIgnoreCase.
]

{ #category : 'Not categorized' }
AISubstringRegexMatcher >> matchesAnyLineIn: linesString [

	^ linesString includesSubstring: regex caseSensitive: ignoreCase not
]

{ #category : 'Not categorized' }
AISubstringRegexMatcher >> matchesLine: lineString [

	^ self matchesAnyLineIn: lineString
]
