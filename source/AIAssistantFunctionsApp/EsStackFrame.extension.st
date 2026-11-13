Extension {
	#name : 'EsStackFrame'
}

{ #category : 'AIAssistant' }
EsStackFrame >> aiJSONInContext: aiContext stringsLimitedTo: limit indexedLimitedTo: indexedLimit [
	"Answer a JSON-serializable dictionary representing the receiver stack frame,
	 including its signature, receiver reference, arguments, and temporaries."

	| frameDict receiverJSON vars argsDict tempsDict |

	frameDict := EsOrderedDictionary new.
	frameDict at: 'signature' put: self printString.

	"Guard against errors when accessing the frame receiver."
	receiverJSON := [ self receiver aiJSONReferenceInContext: aiContext printStringLimitedTo: limit ]
		on: Error
		do: [ :ex | ex return: (EsOrderedDictionary with: 'error' -> 'Could not read receiver') ].
	frameDict at: 'receiver' put: receiverJSON.

	"Use EmSourceManager to resolve source-level parameter and temporary variable names,
	 falling back to runtime slot names (arg1, temp1, etc.) if source parsing fails."
	vars := [ EmSourceManager new visibleVariablesFor: self ]
		on: Error
		do: [ :ex | ex return: self visibleVariables ].
	argsDict := EsOrderedDictionary new.
	tempsDict := EsOrderedDictionary new.

	vars do: [ :var |
		| varName varJSON |
		varName := var name asString.
		"Guard against errors when reading individual stack frame variable slots."
		varJSON := [ var value aiJSONReferenceInContext: aiContext printStringLimitedTo: limit ]
			on: Error
			do: [ :ex | ex return: (EsOrderedDictionary with: 'error' -> 'Could not read stack variable') ].
		"Check isArgument first since EsFrameArgument is a subclass of EsFrameTemporary."
		var isArgument
			ifTrue: [ argsDict at: varName put: varJSON ]
			ifFalse: [
				var isTemp ifTrue: [ tempsDict at: varName put: varJSON ] ] ].

	frameDict at: 'arguments' put: argsDict.
	frameDict at: 'temporaries' put: tempsDict.

	^ frameDict
]
