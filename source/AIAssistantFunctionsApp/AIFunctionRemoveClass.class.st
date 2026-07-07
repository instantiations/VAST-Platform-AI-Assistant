Class {
	#name : 'AIFunctionRemoveClass',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionRemoveClass >> applyFunctionTo: arguments in: context [

	| className class change |
	
	className := arguments at: 'class'.
	class := self classNamed: className.
	class ifNil: [ ^ EsOrderedDictionary with: 'error' -> ('Class %1 not found' bindWith: className) ].
	
	change := RemoveClassChange removeClassName: className asSymbol.
	context addRefactoryChange: change.
	
	^ EsOrderedDictionary with: 'result' -> 'Successfully created change'
]

{ #category : 'Accessing' }
AIFunctionRemoveClass >> category [

	^ 'Code Modification'
]

{ #category : 'Not categorized' }
AIFunctionRemoveClass >> description [

	^ 'Removes a class.'
]

{ #category : 'Not categorized' }
AIFunctionRemoveClass >> name [

	^ 'remove_class'
]

{ #category : 'Not categorized' }
AIFunctionRemoveClass >> parameters [

	^ {
		AIFunctionParameterRequired name: 'class'
			type: AIFunctionParameterTypeString new
			description: 'The name of the class to remove'.
	}
]
