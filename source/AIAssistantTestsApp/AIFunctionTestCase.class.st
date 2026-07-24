Class {
	#name : 'AIFunctionTestCase',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'accessing' }
AIFunctionTestCase >> applyFunction: functionClass withArguments: args [

	^ self applyFunction: functionClass withArguments: args inContext: self emptyContext
]

{ #category : 'accessing' }
AIFunctionTestCase >> applyFunction: functionClass withArguments: args inContext: context [

	^ functionClass new applyFunctionTo: args in: context
]

{ #category : 'accessing' }
AIFunctionTestCase >> contextWithChange: aChange [

	^ AIFunctionCallContext new
		initializeWith: nil
		filePaths: #()
		codeChanges: (OrderedCollection with: aChange)
]

{ #category : 'accessing' }
AIFunctionTestCase >> emptyContext [

	^ AIFunctionCallContext model: nil filePaths: #() codeChanges: OrderedCollection new
]
