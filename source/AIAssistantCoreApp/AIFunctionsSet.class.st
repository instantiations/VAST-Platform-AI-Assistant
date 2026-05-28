Class {
	#name : 'AIFunctionsSet',
	#superclass : 'Object',
	#instVars : [
		'allFunctions',
		'disabledFunctions'
	],
	#classInstVars : [
		'current'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionsSet class >> clearCurrent [

	self current: nil
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> current [

	^ current
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> current: newFunctionsSet [

	current := newFunctionsSet.
	self changed: #current.
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> resetCurrent [

	self current: self new
]

{ #category : 'Not categorized' }
AIFunctionsSet >> allFunctions [

	^ allFunctions
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

	self functions do: [ :function |
		function name = functionName ifTrue: [
			^ function applyTo: arguments in: functionCallContext ] ].
	^ EsOrderedDictionary with: 'error' -> ('There is no function named "%1"' bindWith: functionName)
]

{ #category : 'Not categorized' }
AIFunctionsSet >> disableFunction: function [

	disabledFunctions add: function.
	self changed: #functions.
]

{ #category : 'Not categorized' }
AIFunctionsSet >> enableFunction: function [

	disabledFunctions remove: function ifAbsent: [ ].
	self changed: #functions.
]

{ #category : 'Not categorized' }
AIFunctionsSet >> functionDeclarationsJSON [

	^ self functions collect: [ :function | function functionDeclarationJSON ]
]

{ #category : 'Not categorized' }
AIFunctionsSet >> functions [

	^ self allFunctions reject: [ :function | disabledFunctions includes: function ]
]

{ #category : 'Not categorized' }
AIFunctionsSet >> initialize [

	super initialize.
	(allFunctions := (AIAbstractFunction allSubclasses reject: [ :subclass | subclass isAbstract ]) collect: [ :subclass | subclass new ])
		sort: [ :function1 :function2 | function1 name < function2 name ].
	disabledFunctions := Set withAll: (allFunctions select: [ :function | function defaultEnabled not ]).
]

{ #category : 'Not categorized' }
AIFunctionsSet >> isFunctionDisabled: function [

	^ disabledFunctions includes: function
]

{ #category : 'Not categorized' }
AIFunctionsSet >> isFunctionEnabled: function [

	^ (self isFunctionDisabled: function) not
]

{ #category : 'Not categorized' }
AIFunctionsSet >> postCopy [

	super postCopy.
	allFunctions := allFunctions copy.
	disabledFunctions := disabledFunctions copy.
]
