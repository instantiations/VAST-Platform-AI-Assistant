Class {
	#name : 'GeminiFunctionsSet',
	#superclass : 'Object',
	#instVars : [
		'functions'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionsSet class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
GeminiFunctionsSet >> applyFunctionCall: functionCall in: functionCallContext [

	| responseJSONObject |

	responseJSONObject := [ self applyFunctionNamed: functionCall name to: functionCall arguments in: functionCallContext ]
		on: Error do: [ :error | EsOrderedDictionary with: 'error' -> 'Error' ].
	^ GeminiContentPartFunctionResponse id: functionCall id name: functionCall name response: responseJSONObject
]

{ #category : 'Not categorized' }
GeminiFunctionsSet >> applyFunctionNamed: functionName to: arguments in: functionCallContext [

	functions do: [ :function |
		function name = functionName ifTrue: [
			^ function applyTo: arguments in: functionCallContext ] ].
	^ EsOrderedDictionary with: 'error' -> ('There is no function named "%1"' bindWith: functionName)
]

{ #category : 'Not categorized' }
GeminiFunctionsSet >> functionDeclarationsJSON [

	^ functions collect: [ :function | function functionDeclarationJSON ]
]

{ #category : 'Not categorized' }
GeminiFunctionsSet >> functions [

	^ functions
]

{ #category : 'Not categorized' }
GeminiFunctionsSet >> initialize [

	super initialize.
	(functions := GeminiAbstractFunction subclasses collect: [ :subclass | subclass new ])
		sort: [ :function1 :function2 | function1 name < function2 name ]
]
