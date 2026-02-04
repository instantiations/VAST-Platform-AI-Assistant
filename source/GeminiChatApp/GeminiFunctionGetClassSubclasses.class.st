Class {
	#name : 'GeminiFunctionGetClassSubclasses',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetClassSubclasses >> applyFunctionTo: arguments in: context [

	^ self response: 'subclasses_per_class'
		collect: [ :class | class subclasses collect: [ :subclass | subclass name ] ]
		forClassesNamed: (arguments at: 'classes')
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassSubclasses >> description [

	^ 'Gets the direct subclasses of each given class.'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassSubclasses >> name [

	^ 'get_class_subclasses'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassSubclasses >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'classes'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Names of the classes' }
]
