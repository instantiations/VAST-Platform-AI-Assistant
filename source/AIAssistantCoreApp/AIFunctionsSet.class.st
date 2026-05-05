Class {
	#name : 'AIFunctionsSet',
	#superclass : 'Object',
	#instVars : [
		'functions'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionsSet class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
AIFunctionsSet >> applyFunctionCall: functionCall in: functionCallContext [

	| responseJSONObject |

	responseJSONObject := [ self applyFunctionNamed: functionCall name to: functionCall arguments in: functionCallContext ]
		on: Error do: [ :error | EsOrderedDictionary with: 'error' -> 'Error' ].
	^ AIChatGeneratedContentPartFunctionResponse id: functionCall id name: functionCall name response: responseJSONObject
]

{ #category : 'Not categorized' }
AIFunctionsSet >> applyFunctionNamed: functionName to: arguments in: functionCallContext [

	functions do: [ :function |
		function name = functionName ifTrue: [
			^ function applyTo: arguments in: functionCallContext ] ].
	^ EsOrderedDictionary with: 'error' -> ('There is no function named "%1"' bindWith: functionName)
]

{ #category : 'Not categorized' }
AIFunctionsSet >> functionDeclarationsJSON [

	^ functions collect: [ :function | function functionDeclarationJSON ]
]

{ #category : 'Not categorized' }
AIFunctionsSet >> functions [

	^ functions
]

{ #category : 'Not categorized' }
AIFunctionsSet >> initialize [

	super initialize.
	(functions := AIAbstractFunction subclasses collect: [ :subclass | subclass new ])
		sort: [ :function1 :function2 | function1 name < function2 name ]
]
