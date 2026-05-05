Class {
	#name : 'AIFunctionListClassesInApplications',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionListClassesInApplications >> applyFunctionTo: arguments in: context [

	| classesPerApplication notFoundApplications |

	classesPerApplication := EsOrderedDictionary new.
	notFoundApplications := OrderedCollection new.

	(arguments at: 'applications') do: [:applicationName |
		(self classesInApplicationNamed: applicationName)
			ifNotEmpty: [:classes |
				classesPerApplication
					at: applicationName
					put: (classes collect: [:class | class name]) sorted]
			ifEmpty: [notFoundApplications add: applicationName]].

	^EsOrderedDictionary
		with: 'classes_per_application' -> classesPerApplication
		with: 'nonexistent_or_outside_scope_applications' -> notFoundApplications
]

{ #category : 'Not categorized' }
AIFunctionListClassesInApplications >> description [

	^ 'Returns a Dictionary where keys are application names and values are lists of class names defined in those applications.'
]

{ #category : 'Not categorized' }
AIFunctionListClassesInApplications >> name [

	^ 'list_classes_in_applications'
]

{ #category : 'Not categorized' }
AIFunctionListClassesInApplications >> parameters [

	^ {
		AIFunctionParameterRequired name: 'applications'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Names of the applications' }
]
