Extension {
	#name : 'Object'
}

{ #category : 'AIAssistant',
  #vaVisibility : 'private' }
Object >> aiInstanceVariablesJSONInContext: context stringsLimitedTo: stringLimit [

	| instVars |

	instVars := EsOrderedDictionary new.
	self class allInstVarNames keysAndValuesDo: [ :index :name |
		[ | varVal |
			varVal := self instVarAt: index.
			instVars
				at: name
				put: (varVal aiJSONReferenceInContext: context printStringLimitedTo: stringLimit) ]
					on: Error
					do: [ :ex |
						instVars
							at: name
							put: (EsOrderedDictionary with: 'error' -> 'Could not read instance variable').
						ex return: nil ] ].
	^ instVars
]

{ #category : 'AIAssistant' }
Object >> aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit [

	| dict |

	dict := self aiJSONReferenceInContext: context printStringLimitedTo: stringLimit.
	dict
		at: 'instance_variables'
		put: (self aiInstanceVariablesJSONInContext: context stringsLimitedTo: stringLimit).

	(self class isVariable and: [ self class isPointers ]) ifTrue: [
		| size limit elements |
		size := [ self basicSize ] on: Error do: [ :ex | ex return: 0 ].
		dict at: 'size' put: size.
		limit := (size min: indexedLimit) max: 0.
		elements := OrderedCollection new: limit.
		1 to: limit do: [ :index |
			[ | varVal |
				varVal := self basicAt: index.
				elements add: (varVal aiJSONReferenceInContext: context printStringLimitedTo: stringLimit) ]
					on: Error
					do: [ :ex |
						elements add: (EsOrderedDictionary with: 'error' -> 'Could not read indexed slot').
						ex return: nil ] ].
		dict at: 'elements' put: elements ].

	^ dict
]

{ #category : 'AIAssistant' }
Object >> aiJSONReferenceInContext: context printStringLimitedTo: limit [

	| dict |

	dict := EsOrderedDictionary new.
	dict
		at: 'class' put: self class name asString;
		at: 'print_string' put: ([ self printStringLimitedTo: limit ]
			on: Error
			do: [ :sig | sig return: 'Could not print object' ]);
		at: 'object_handle' put: (context objectRegistry register: self).

	^ dict
]
