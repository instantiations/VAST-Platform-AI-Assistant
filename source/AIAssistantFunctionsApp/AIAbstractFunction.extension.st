Extension {
	#name : 'AIAbstractFunction'
}

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> isClassSideParametervalue: side [

	side = 'instance' ifTrue: [^ false].
	side = 'class' ifTrue:[ ^ true ].
	^ nil
]

{ #category : 'System Search',
  #vaVisibility : 'private' }
AIAbstractFunction >> regexMatcherForArgumentsIn: functionArguments onSyntaxError: errorBlock [

	^ [ AIRegexMatcher forRegex: (functionArguments at: 'regex') ignoreCase: (functionArguments at: 'ignore_case' ifAbsent: [ false ]) ] on: RegexSyntaxError
		do: [ :error | errorBlock value: (EsOrderedDictionary with: 'error' -> ('Syntax error in regular expression at position %1: %2' bindWith: error position with: error messageText)) ]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> validate: code from: startIndex forEvaluation: forEvaluation context: context [

	| selectors methodParseNode proposedSelectors |

	methodParseNode :=
		AISmalltalkParser
			parse: (code copyFrom: startIndex to: code size)
			messagePattern: forEvaluation not
			scanComments: true
			onError: [:errorString :sourcePosition |
				^EsOrderedDictionary with:
					'error' -> ('Syntax error in given code at position %1: %2' bindWith: (sourcePosition + startIndex - 1) asString with: errorString)].

	proposedSelectors :=
		context ifNil: [Set new] ifNotNil: [context proposedSelectors].

	selectors :=
		methodParseNode messagesSent reject: [:selector |
			(proposedSelectors includes: selector)
				or: [StsPowerTools methodSelectorExistsInSystem: selector]].

	selectors ifNotEmpty: [
		^EsOrderedDictionary with:
			'error' -> ('Sends selectors that have no implementors: ' ,((selectors sorted collect: [:selector | selector printString]) joinUsing: ', '))].
	^EsOrderedDictionary with: 'valid' -> true
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> withLineStreamWithRewindLimit: rewindLimit forFileIn: functionArguments in: functionCallContext do: block [

	| fileNumber filePath startPosition |

	fileNumber := functionArguments at: 'file_number'.
	filePath := functionCallContext filePaths at: fileNumber ifAbsent: [
		^ EsOrderedDictionary with: 'error' -> ('There is no file numbered %1' bindWith: fileNumber) ].
	startPosition := (functionArguments at: 'start' ifAbsent: [ 1 ]) - 1.
	filePath readStreamDo: [ :fileStream |
		| lineStream |
		(lineStream := AIRewindableStream on: (AILineStream on: fileStream) rewindLimit: rewindLimit)
			position: startPosition.
		^ block value: lineStream ].
	^ EsOrderedDictionary with: 'error' -> 'The file could not be opened, it may have been removed'
]
