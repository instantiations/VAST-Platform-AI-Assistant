Class {
	#name : 'AIAbstractRegexMatcher',
	#superclass : 'Object',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIAbstractRegexMatcher class >> forRegex: regexString ignoreCase: ignoreCase [

	| subRegexString |

	subRegexString := regexString
		copyFrom: ((regexString beginsWithSubCollection: '.*') ifTrue: [ 3 ] ifFalse: [ 1 ])
		to: regexString size - ((regexString size > 2 and: [ regexString endsWithSubCollection: '.*' ]) ifTrue: [ 2 ] ifFalse: [ 0 ]).
	^ ((subRegexString matchesRegex: '[ !"#%&'',/0-9;<=>@A-Z_`a-z~-]*')
		ifTrue: [ AISubstringRegexMatcher ] ifFalse: [ AIRegexMatcher ])
			basicNew initializeWithRegex: subRegexString ignoreCase: ignoreCase
]

{ #category : 'Not categorized' }
AIAbstractRegexMatcher >> initializeWithRegex: regex ignoreCase: ignoreCase [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractRegexMatcher >> matchesAnyLineIn: linesString [

	| lineStream |

	lineStream := AILineStream on: linesString readStream.
	[ lineStream atEnd ] whileFalse: [
		(self matchesLine: lineStream next) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : 'Not categorized' }
AIAbstractRegexMatcher >> matchesLine: lineString [

	self subclassResponsibility
]
