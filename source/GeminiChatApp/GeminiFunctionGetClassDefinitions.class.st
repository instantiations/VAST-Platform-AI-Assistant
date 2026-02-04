Class {
	#name : 'GeminiFunctionGetClassDefinitions',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetClassDefinitions >> applyFunctionTo: arguments in: context [

	^ self response: 'definition_per_class'
		collect: [ :class | class geminiJSON ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassDefinitions >> description [

	^ 'Gets the definitions of each class: its superclass, its instance variables, its class variables and the application it is defined by.'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassDefinitions >> name [

	^ 'get_class_definitions'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassDefinitions >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'classes'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Names of the classes' }
]
