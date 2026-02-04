Class {
	#name : 'GeminiSubstringRegexMatcher',
	#superclass : 'GeminiAbstractRegexMatcher',
	#instVars : [
		'ignoreCase',
		'regex'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiSubstringRegexMatcher >> initializeWithRegex: initialRegex ignoreCase: initialIgnoreCase [

	self initialize.
	regex := initialRegex.
	ignoreCase := initialIgnoreCase.
]

{ #category : 'Not categorized' }
GeminiSubstringRegexMatcher >> matchesAnyLineIn: linesString [

	^ linesString includesSubstring: regex caseSensitive: ignoreCase not
]

{ #category : 'Not categorized' }
GeminiSubstringRegexMatcher >> matchesLine: lineString [

	^ self matchesAnyLineIn: lineString
]
