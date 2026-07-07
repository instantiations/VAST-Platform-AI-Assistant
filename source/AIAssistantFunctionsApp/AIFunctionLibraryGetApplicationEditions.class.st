Class {
	#name : 'AIFunctionLibraryGetApplicationEditions',
	#superclass : 'AIAbstractLibraryFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionLibraryGetApplicationEditions >> applyFunctionTo: arguments in: context [
	| appName appClass shadows editions |
	
	appName := arguments at: 'application'.
	appClass := self applicationNamed: appName.
	appClass ifNil: [ 
		^ EsOrderedDictionary with: 'error' -> ('Application not found: ', appName) ].
	
	shadows := appClass shadows.
	editions := shadows collect: [:each | each aiJSON ].
	
	^ EsOrderedDictionary with: 'editions' -> editions
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetApplicationEditions >> description [
	^ 'Lists the editions/versions of an application, providing their version names and timestamps.'
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetApplicationEditions >> name [
	^ 'get_application_editions'
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetApplicationEditions >> parameters [
	^ {
		AIFunctionParameterRequired name: 'application'
			type: AIFunctionParameterTypeString new
			description: 'The name of the application'.
	}
]
