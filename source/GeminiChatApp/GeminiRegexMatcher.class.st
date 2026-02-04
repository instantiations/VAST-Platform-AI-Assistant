Class {
	#name : 'GeminiRegexMatcher',
	#superclass : 'GeminiAbstractRegexMatcher',
	#instVars : [
		'rxMatcher'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiRegexMatcher >> initializeWithRegex: regex ignoreCase: ignoreCase [

	self initialize.
	rxMatcher := RxMatcher forString: regex ignoreCase: ignoreCase.
]

{ #category : 'Not categorized' }
GeminiRegexMatcher >> matchesLine: lineString [

	^ rxMatcher search: lineString
]
