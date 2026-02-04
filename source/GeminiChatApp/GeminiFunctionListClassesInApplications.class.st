Class {
	#name : 'GeminiFunctionListClassesInApplications',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionListClassesInApplications >> applyFunctionTo: arguments in: context [

	| classesPerApplication notFoundApplications |

	classesPerApplication := EsOrderedDictionary new.
	notFoundApplications := OrderedCollection new.

	(arguments at: 'applications') do: [:applicationName |
		(self classesInApplicationNamed: applicationName) ifNotNil: [ :classes |
			classesPerApplication
				at: applicationName
				put: (classes collect: [ :class | class name ]) sorted
		] ifNil: [
			notFoundApplications add: applicationName ] ].

	^ EsOrderedDictionary
		with: 'classes_per_application' -> classesPerApplication
		with: 'nonexistent_or_outside_scope_applications' -> notFoundApplications
]

{ #category : 'Not categorized' }
GeminiFunctionListClassesInApplications >> description [

	^ 'Returns a Dictionary where keys are application names and values are lists of class names defined in those applications.'
]

{ #category : 'Not categorized' }
GeminiFunctionListClassesInApplications >> name [

	^ 'list_classes_in_applications'
]

{ #category : 'Not categorized' }
GeminiFunctionListClassesInApplications >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'applications'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Names of the applications' }
]
