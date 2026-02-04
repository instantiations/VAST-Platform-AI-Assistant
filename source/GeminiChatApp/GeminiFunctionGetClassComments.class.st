Class {
	#name : 'GeminiFunctionGetClassComments',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetClassComments >> applyFunctionTo: arguments in: context [

	^ self response: 'comment_per_class'
		collect: [ :class | class comment ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassComments >> description [

	^ 'Gets the comment of each class.'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassComments >> name [

	^ 'get_class_comment'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassComments >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'classes'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Names of the classes' }
]
