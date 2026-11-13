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

{ #category : 'Accessing' }
AIFunctionListClassesInApplications >> category [

	^ 'Code Exploration'
]

{ #category : 'Not categorized' }
AIFunctionListClassesInApplications >> description [

	^ 'Returns a Dictionary where keys are application names and values are the names of classes defined or extended in that application, including all of its subapplications (recursively). Passing a subapplication returns only that subapplication and the subapplications below it.'
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
