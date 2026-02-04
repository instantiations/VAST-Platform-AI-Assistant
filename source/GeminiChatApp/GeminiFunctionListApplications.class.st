Class {
	#name : 'GeminiFunctionListApplications',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionListApplications >> applyFunctionTo: arguments in: context [

	^ EsOrderedDictionary with: 'applications' -> (System loadedSubApplications collect: [ :application | application name ]) sorted
]

{ #category : 'Not categorized' }
GeminiFunctionListApplications >> description [

	^ 'Lists all of the applications.'
]

{ #category : 'Not categorized' }
GeminiFunctionListApplications >> name [

	^ 'list_applications'
]

{ #category : 'Not categorized' }
GeminiFunctionListApplications >> parameters [

	^ { }
]
