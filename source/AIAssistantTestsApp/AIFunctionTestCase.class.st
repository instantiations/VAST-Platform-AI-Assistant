Class {
	#name : 'AIFunctionTestCase',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Helpers' }
AIFunctionTestCase >> applyFunction: functionClass withArguments: args [

	^ self applyFunction: functionClass withArguments: args inContext: self emptyContext
]

{ #category : 'Helpers' }
AIFunctionTestCase >> applyFunction: functionClass withArguments: args inContext: context [

	^ functionClass new applyFunctionTo: args in: context
]

{ #category : 'Helpers' }
AIFunctionTestCase >> contextWithChange: aChange [

	^ AIFunctionCallContext new
		initializeWith: nil
		filePaths: #()
		codeChanges: (OrderedCollection with: aChange)
]

{ #category : 'Helpers' }
AIFunctionTestCase >> emptyContext [

	^ AIFunctionCallContext model: nil filePaths: #() codeChanges: OrderedCollection new
]
