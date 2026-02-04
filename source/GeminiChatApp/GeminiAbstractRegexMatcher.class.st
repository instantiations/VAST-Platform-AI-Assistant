Class {
	#name : 'GeminiAbstractRegexMatcher',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractRegexMatcher class >> forRegex: regexString ignoreCase: ignoreCase [

	| subRegexString |

	subRegexString := regexString
		copyFrom: ((regexString beginsWithSubCollection: '.*') ifTrue: [ 3 ] ifFalse: [ 1 ])
		to: regexString size - ((regexString size > 2 and: [ regexString endsWithSubCollection: '.*' ]) ifTrue: [ 2 ] ifFalse: [ 0 ]).
	^ ((subRegexString matchesRegex: '[ !"#%&'',/0-9;<=>@A-Z_`a-z~-]*')
		ifTrue: [ GeminiSubstringRegexMatcher ] ifFalse: [ GeminiRegexMatcher ])
			basicNew initializeWithRegex: subRegexString ignoreCase: ignoreCase
]

{ #category : 'Not categorized' }
GeminiAbstractRegexMatcher >> initializeWithRegex: regex ignoreCase: ignoreCase [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractRegexMatcher >> matchesAnyLineIn: linesString [

	| lineStream |

	lineStream := GeminiLineStream on: linesString readStream.
	[ lineStream atEnd ] whileFalse: [
		(self matchesLine: lineStream next) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : 'Not categorized' }
GeminiAbstractRegexMatcher >> matchesLine: lineString [

	self subclassResponsibility
]
