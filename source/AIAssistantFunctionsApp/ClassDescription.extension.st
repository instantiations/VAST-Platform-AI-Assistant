Extension {
	#name : 'ClassDescription'
}

{ #category : 'AIAssistant' }
ClassDescription >> aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit [

	| dict targetClass classVars |

	dict := super aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit.

	targetClass := self asClass.
	classVars := EsOrderedDictionary new.
	targetClass allClassVarNames sorted do: [ :varName | | assoc |
			assoc := targetClass classVariableAssociationFor: varName.
			assoc ifNotNil: [
				classVars
					at: varName asString
					put: (assoc value aiJSONReferenceInContext: context printStringLimitedTo: stringLimit)]].
	dict at: 'class_variables' put: classVars.

	^ dict
]
