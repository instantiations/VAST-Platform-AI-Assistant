Extension {
	#name : 'EsStackFrame'
}

{ #category : 'AIAssistant' }
EsStackFrame >> aiJSONWithStringsLimitedTo: limit [

	| frameDict vars argsDict tempsDict printBlock |

	frameDict := EsOrderedDictionary new.
	frameDict at: 'signature' put: self printString.

	printBlock := [:value |
		[value printStringLimitedTo: limit]
			on: Error
			do: [:sig | sig return: 'Could not print variable']].

	frameDict at: 'receiver_class' put: self receiverClass name asString.
	frameDict at: 'receiver' put: (printBlock value: self receiver).

	vars := self visibleVariables.
	argsDict := EsOrderedDictionary new.
	tempsDict := EsOrderedDictionary new.

	vars do: [:var |
		var isArgument
			ifTrue: [argsDict at: var name put: (printBlock value: var value)]
			ifFalse: [var isTemp ifTrue: [tempsDict at: var name put: (printBlock value: var value)]]].

	frameDict at: 'arguments' put: argsDict.
	frameDict at: 'temporaries' put: tempsDict.

	^frameDict
]
