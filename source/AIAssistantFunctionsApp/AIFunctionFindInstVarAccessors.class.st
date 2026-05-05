Class {
	#name : 'AIFunctionFindInstVarAccessors',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionFindInstVarAccessors >> applyFunctionTo: arguments in: context [

	| className instVarName instVarIndex class methods |

	className := arguments at: 'class'.
	instVarName := arguments at: 'instance_variable'.

	class := self classNamed: className.
	class ifNil: [^EsOrderedDictionary with: 'error' -> ('Class %1 not found' bindWith: className)].

	methods := OrderedCollection new.

	[ "Manually find the index and check methods to avoid using #whichSelectorsAccess:"
		instVarIndex := class allInstVarNames indexOf: instVarName.
		instVarIndex > 0]
			whileTrue: [
				class methodDictionary do: [:method |
					(method referencesInstVar: instVarIndex) ifTrue: [methods add: method geminiJSON]].
				"Search superclasses as well"
				class := class superclass].

	^EsOrderedDictionary with: 'methods' -> methods
]

{ #category : 'Not categorized' }
AIFunctionFindInstVarAccessors >> description [

	^ 'Returns methods referencing the provided instance variable. Searches class as well as its superclasses'
]

{ #category : 'Not categorized' }
AIFunctionFindInstVarAccessors >> name [

	^ 'find_inst_var_accessors'
]

{ #category : 'Not categorized' }
AIFunctionFindInstVarAccessors >> parameters [

	^ {
		AIFunctionParameterRequired name: 'class'
			type: AIFunctionParameterTypeString new
			description: 'The name a class where instance variable is defined'.
		AIFunctionParameterRequired name: 'instance_variable'
			type: AIFunctionParameterTypeString new
			description: 'The name of the instance variable' }
]
