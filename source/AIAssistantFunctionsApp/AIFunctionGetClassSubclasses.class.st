Class {
	#name : 'AIFunctionGetClassSubclasses',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionGetClassSubclasses >> applyFunctionTo: arguments in: context [

	^ self response: 'subclasses_per_class'
		collect: [ :class | class subclasses collect: [ :subclass | subclass name ] ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'Not categorized' }
AIFunctionGetClassSubclasses >> description [

	^ 'Gets the direct subclasses of each given class.'
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
			description: 'Names of the classes' }
]
