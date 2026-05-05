Class {
	#name : 'AIFunctionGetClassDefinitions',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionGetClassDefinitions >> applyFunctionTo: arguments in: context [

	^ self response: 'definition_per_class'
		collect: [ :class | class geminiJSON ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'Not categorized' }
AIFunctionGetClassDefinitions >> description [

	^ 'Gets the shape of classes: their superclass, instance variables, class variables, and the application it is defined by.'
]

{ #category : 'Not categorized' }
AIFunctionGetClassDefinitions >> name [

	^ 'get_class_definitions'
]

{ #category : 'Not categorized' }
AIFunctionGetClassDefinitions >> parameters [

	^ {
		AIFunctionParameterRequired name: 'classes'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Names of the classes' }
]
