Class {
	#name : 'AIFunctionGetClassSubclasses',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionGetClassSubclasses >> applyFunctionTo: arguments in: context [

	| includeIndirect requestedClassNames targetClassNames |

	includeIndirect := arguments at: 'include_indirect' ifAbsent: [false].
	requestedClassNames := arguments at: 'classes'.

	targetClassNames :=
		includeIndirect
			ifFalse: [requestedClassNames]
			ifTrue: [| expanded |
				expanded := Set new.
				requestedClassNames do: [:name |
					expanded add: name asString.
					(self classNamed: name) ifNotNil: [:class |
						class allSubclassesDo: [:subclass | expanded add: subclass name asString]]].
				expanded asArray].

	^self
		response: 'subclasses_per_class'
		collect: [:class | class subclasses collect: [:subclass | subclass name asString]]
		forClassesNamed: targetClassNames sorted
]

{ #category : 'Accessing' }
AIFunctionGetClassSubclasses >> category [

	^ 'Code Exploration'
]

{ #category : 'Not categorized' }
AIFunctionGetClassSubclasses >> description [
	^ 'Gets the subclasses of each given class. If include_indirect is true, it recursively includes all indirect subclasses, mapping each to its direct subclasses.'
]

{ #category : 'Not categorized' }
AIFunctionGetClassSubclasses >> name [

	^ 'get_class_subclasses'
]

{ #category : 'Not categorized' }
AIFunctionGetClassSubclasses >> parameters [
	^ {
		AIFunctionParameterRequired name: 'classes'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Names of the classes'.
		AIFunctionParameterOptional name: 'include_indirect'
			type: AIFunctionParameterTypeBoolean new
			description: 'Whether to include all indirect subclasses as well by returning an entry for each subclass mapping to its direct subclasses. Defaults to false.' }
]
