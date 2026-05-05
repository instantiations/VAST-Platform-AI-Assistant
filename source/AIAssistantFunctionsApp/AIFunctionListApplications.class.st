Class {
	#name : 'AIFunctionListApplications',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionListApplications >> applyFunctionTo: arguments in: context [

	^ EsOrderedDictionary with: 'applications' -> (System loadedSubApplications collect: [ :application | application name ]) sorted
]

{ #category : 'Not categorized' }
AIFunctionListApplications >> description [

	^ 'Lists all of the applications.'
]

{ #category : 'Not categorized' }
AIFunctionListApplications >> name [

	^ 'list_applications'
]

{ #category : 'Not categorized' }
AIFunctionListApplications >> parameters [

	^ { }
]
