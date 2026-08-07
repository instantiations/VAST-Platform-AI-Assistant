Class {
	#name : 'AIFunctionRemoveMethod',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionRemoveMethod >> applyFunctionTo: arguments in: context [

	| className class selector behavior side change |

	className := arguments at: 'class'.
	class := self classNamed: className.
	class ifNil: [^EsOrderedDictionary with: 'error' -> ('Class %1 not found' bindWith: className)].

	side := arguments at: 'side' ifAbsent: ['instance'].
	(self isClassSideParametervalue: side)
		ifNil: [^EsOrderedDictionary with: 'error' -> ('Invalid value for parameter ''side'': %1' bindWith: side)]
		ifNotNil: [:isClassSide | behavior := isClassSide ifTrue: [class class] ifFalse: [class]].

	selector := (arguments at: 'selector') asSymbol.
	(behavior includesSelector: selector) ifFalse:[ ^EsOrderedDictionary with: 'error' -> ('%1 does not implement selector %2.' bindWith: behavior name with: selector)].
	
	change := AIRemoveMethodChange remove: selector from: behavior application: (behavior compiledMethodAt: selector) application.
	context addRefactoryChange: change.

	^EsOrderedDictionary
		with: 'result' -> 'Successfully created change'
]

{ #category : 'Accessing' }
AIFunctionRemoveMethod >> category [

	^ 'Code Modification'
]

{ #category : 'Accessing' }
AIFunctionRemoveMethod >> description [

	^'Removes a method from a class.'
]

{ #category : 'Accessing' }
AIFunctionRemoveMethod >> name [

	^'remove_method'
]

{ #category : 'Accessing' }
AIFunctionRemoveMethod >> parameters [

	^{
		AIFunctionParameterRequired name: 'class'
			type: AIFunctionParameterTypeString new
			description: 'The name of the class'.
		AIFunctionParameterRequired name: 'selector'
			type: AIFunctionParameterTypeString new
			description: 'The selector of the method to remove'.
		AIFunctionParameterOptional name: 'side'
			type: AIFunctionParameterTypeString new
			description: '''instance'' for an instance method, ''class'' for a class method. Defaults to ''instance''.' }
]
