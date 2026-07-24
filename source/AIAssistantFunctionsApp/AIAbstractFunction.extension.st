Extension {
	#name : 'AIAbstractFunction'
}

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> checkClassName: className [

	(RBCondition validClassName: className) ifFalse: [
		^EsOrderedDictionary with: 'error' -> ('Invalid class name: %1. Provide a valid Smalltalk class name.' bindWith: className) ].
	^ nil
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> isClassSideParametervalue: side [

	side = 'instance' ifTrue: [^ false].
	side = 'class' ifTrue:[ ^ true ].
	^ nil
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> isVariable: varName resolvableWithLocals: localVariableNames proposedClasses: proposedClasses proposedVariables: proposedVariables targetClassName: targetClassName isClassSide: isClassSide [

	| proposedInstVars proposedClassVars proposedPoolNames |

	(#('self' 'super' 'true' 'false' 'nil') includes: varName) ifTrue: [ ^ true ].
	(localVariableNames includes: varName) ifTrue: [ ^ true ].
	(proposedClasses includes: varName) ifTrue: [ ^ true ].
	(StsPowerTools globalExists: varName) ifTrue: [ ^ true ].

	(self isVariable: varName visibleInTargetClass: targetClassName isClassSide: isClassSide) ifTrue: [ ^ true ].
	
	proposedInstVars := proposedVariables at: 1.
	proposedClassVars := proposedVariables at: 2.
	proposedPoolNames := proposedVariables at: 3.
	
	(proposedInstVars includes: varName) ifTrue: [ ^ true ].
	(proposedClassVars includes: varName) ifTrue: [ ^ true ].
	
	proposedPoolNames do: [:poolName |
		(Smalltalk at: poolName asSymbol ifAbsent: [nil])
			ifNotNil: [:pool |
				((pool includesKey: varName asSymbol)
					or: [pool includesKey: varName asString])
						ifTrue: [ ^ true ] ] ].
						
	^ false
]

{ #category : 'Internal' }
AIAbstractFunction >> isVariable: varName visibleInTargetClass: targetClassName isClassSide: isClassSide [

	targetClassName ifNotNil: [
		(Smalltalk classAt: targetClassName asSymbol) ifNotNil: [ :targetClass |
			| targetClassForVars |
			targetClassForVars := isClassSide ifTrue: [ targetClass class ] ifFalse: [ targetClass ].
			(targetClassForVars allInstVarNames includes: varName) ifTrue: [ ^ true ].
			(targetClass allClassVarNames includes: varName) ifTrue: [ ^ true ].
			(targetClass allSharedPoolNames anySatisfy: [:poolName |
				| pool |
				pool := Smalltalk at: poolName asSymbol ifAbsent: [ nil ].
				pool notNil and: [
					(pool includesKey: varName asSymbol) or: [ pool includesKey: varName asString ] ] ])
					ifTrue: [ ^ true ] ] ].
	^ false
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> proposedVariablesFrom: context forClass: targetClassName isClassSide: isClassSide [
	"Returns the triple { instanceVariables . classVariables . poolDictionaryNames } for the last proposed class definition for the class named @targetClassName in the context."
	
	| proposedInstVars proposedClassVars proposedPoolNames |
	proposedInstVars := Set new.
	proposedClassVars := Set new.
	proposedPoolNames := Set new	.

	context ifNotNil: [ | lastClassChange |
		lastClassChange := (context codeChanges select: [:change | change aiIsClassChangeForClassNamed: targetClassName]) ifEmpty: [nil] ifNotEmpty:[:classChanges | classChanges last].
		lastClassChange
			ifNotNil:[
				isClassSide 
					ifTrue: [ proposedInstVars addAll: lastClassChange classInstanceVariableNames ]
					ifFalse: [ proposedInstVars addAll: lastClassChange instanceVariableNames ].
				proposedClassVars addAll: lastClassChange classVariableNames.
				proposedPoolNames addAll: lastClassChange poolDictionaryNames]].

	^{ proposedInstVars. proposedClassVars. proposedPoolNames }
]

{ #category : 'System Search',
  #vaVisibility : 'private' }
AIAbstractFunction >> regexMatcherForArgumentsIn: functionArguments onSyntaxError: errorBlock [

	^ [ AIRegexMatcher forRegex: (functionArguments at: 'regex') ignoreCase: (functionArguments at: 'ignore_case' ifAbsent: [ false ]) ] on: RegexSyntaxError
		do: [ :error | errorBlock value: (EsOrderedDictionary with: 'error' -> ('Syntax error in regular expression at position %1: %2' bindWith: error position with: error messageText)) ]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> undefinedVariablesIn: methodParseNode context: context targetClassName: targetClassName isClassSide: isClassSide [

	| proposedVariables localVariableNames proposedClasses undefinedVariables |

	proposedVariables := self proposedVariablesFrom: context forClass: targetClassName isClassSide: isClassSide.
	localVariableNames := (methodParseNode allLocals collect: [:node | node contents asString]) asSet.
	proposedClasses := context ifNil: [Set new] ifNotNil: [context proposedClasses].
	undefinedVariables := Set new.

	methodParseNode allNodesDo: [:node |
		node isVariable
			ifTrue: [
				| varName |
				varName := node contents asString.
				(self 
					isVariable: varName 
					resolvableWithLocals: localVariableNames 
					proposedClasses: proposedClasses 
					proposedVariables: proposedVariables 
					targetClassName: targetClassName 
					isClassSide: isClassSide) 
						ifFalse: [ undefinedVariables add: varName ] ] ].

	^ undefinedVariables
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> validate: code forEvaluation: forEvaluation context: context targetClassName: targetClassName isClassSide: isClassSide [

	| methodParseNode |

	methodParseNode :=
		AISmalltalkParser
			parse: code
			messagePattern: forEvaluation not
			scanComments: true
			onError: [:errorString :sourcePosition |
				^EsOrderedDictionary with:
					'error' -> ('Syntax error in given code at position ', sourcePosition asString, ': ', errorString)].
					
	(self validateMessagesSentIn: methodParseNode context: context) ifNotNil: [:error | ^ error ].
	(self validateVariableReferencesIn: methodParseNode context: context targetClassName: targetClassName isClassSide: isClassSide) ifNotNil: [:error | ^ error ].
	
	^EsOrderedDictionary with: 'valid' -> true
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> validateMessagesSentIn: methodParseNode context: context [

	| proposedSelectors selectors |

	proposedSelectors := context ifNil: [Set new] ifNotNil: [context proposedSelectors].

	selectors :=
		methodParseNode messagesSent reject: [:selector |
			(proposedSelectors includes: selector)
				or: [StsPowerTools methodSelectorExistsInSystem: selector]].

	^selectors
		ifEmpty: [nil]
		ifNotEmpty: [
			EsOrderedDictionary with:
				'error' -> ('Sends selectors that have no implementors: ' , ((selectors sorted collect: [:selector | selector printString]) joinUsing: ', '))]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractFunction >> validateVariableReferencesIn: methodParseNode context: context targetClassName: targetClassName isClassSide: isClassSide [

	| undefinedVariables |

	undefinedVariables := self undefinedVariablesIn: methodParseNode context: context targetClassName: targetClassName isClassSide: isClassSide.

	^undefinedVariables
		ifEmpty: [nil]
		ifNotEmpty: [
			EsOrderedDictionary with:
				'error' -> ('References unknown variables, classes or globals: ' , ((undefinedVariables asSortedCollection collect: [:name | name printString]) joinUsing: ', '))]
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
