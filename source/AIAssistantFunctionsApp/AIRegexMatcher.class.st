Class {
	#name : 'AIRegexMatcher',
	#superclass : 'AIAbstractRegexMatcher',
	#instVars : [
		'rxMatcher'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIRegexMatcher >> initializeWithRegex: regex ignoreCase: ignoreCase [

	self initialize.
	rxMatcher := RxMatcher forString: regex ignoreCase: ignoreCase.
]

{ #category : 'Not categorized' }
AIRegexMatcher >> matchesLine: lineString [

	^ rxMatcher search: lineString
]
