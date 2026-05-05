Class {
	#name : 'AIFunctionGetClassComments',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionGetClassComments >> applyFunctionTo: arguments in: context [

	^ self response: 'comment_per_class'
		collect: [ :class | class comment ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'Not categorized' }
AIFunctionGetClassComments >> description [

	^ 'Gets the comment of each class.'
]

{ #category : 'Not categorized' }
AIFunctionGetClassComments >> name [

	^ 'get_class_comment'
]

{ #category : 'Not categorized' }
AIFunctionGetClassComments >> parameters [

	^ {
		AIFunctionParameterRequired name: 'classes'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Names of the classes' }
]
