Class {
	#name : 'AIFunctionFindInstVarAccessors',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionFindInstVarAccessors >> applyFunctionTo: arguments in: context [

	| className instVarName theClass methods |

	className := arguments at: 'class'.
	instVarName := arguments at: 'instance_variable'.

	theClass := self classNamed: className.
	theClass
		ifNil: [^EsOrderedDictionary with: 'error' -> ('Class %1 not found' bindWith: className)].

	(theClass allInstVarNames includes: instVarName) ifFalse: [
		^EsOrderedDictionary with: 'error' -> ('Instance variable %1 not found in class %2' bindWith: instVarName with: className)].

	methods := (theClass allMethodsReferencingInstVarName: instVarName)
		collect: [:each | each aiJSON].

	^EsOrderedDictionary with: 'methods' -> methods
]

{ #category : 'Accessing' }
AIFunctionFindInstVarAccessors >> category [

	^ 'Code Exploration'
]

{ #category : 'Not categorized' }
AIFunctionFindInstVarAccessors >> description [

	^ 'Returns methods referencing the provided instance variable. Searches the provided class as well as its superclasses and all (direct and indirect) subclasses.'
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
			description: 'The name of the class where the instance variable is defined or inherited'.
		AIFunctionParameterRequired name: 'instance_variable'
			type: AIFunctionParameterTypeString new
			description: 'The name of the instance variable' }
]
