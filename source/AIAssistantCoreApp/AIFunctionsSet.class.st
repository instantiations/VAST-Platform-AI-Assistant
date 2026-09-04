Class {
	#name : 'AIFunctionsSet',
	#superclass : 'Object',
	#instVars : [
		'allFunctions',
		'disabledFunctions',
		'functionsRequiringPermission'
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

	CwAppContext default syncExecInUI: [
		current := newFunctionsSet.
		self changed: #current ]
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> functions: functions [

	^ self basicNew initializeWithFunctions: functions
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> new [

	^ self functions: OrderedCollection new
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> resetCurrent [

	self current: self withDefaultFunctions
]

{ #category : 'Not categorized' }
AIFunctionsSet class >> withDefaultFunctions [

	| functions |

	(functions := OrderedCollection new)
		addAll: (((AIAbstractFunction allSubclasses reject: [ :subclass | subclass isAbstract ]) collect: [ :subclass | subclass new ])
			sorted: [ :function1 :function2 | function1 name < function2 name ]).
	(AIAbstractMCPServer registeredServers sorted: [ :server1 :server2 | server1 name < server2 name ]) do: [ :server |
		functions addAll: (server functions sorted: [ :function1 :function2 | function1 name < function2 name ]) ].
	^ self functions: functions
]

{ #category : 'Not categorized' }
AIFunctionsSet >> allFunctions [

	^ allFunctions
]

{ #category : 'Not categorized' }
AIFunctionsSet >> disableFunction: function [

	disabledFunctions add: function.
	self changed: #functions.
]

{ #category : 'Not categorized' }
AIFunctionsSet >> dontRequirePermissionToCallFunction: function [

	functionsRequiringPermission remove: function ifAbsent: [ ].
	self changed: #functionsRequiringPermission.
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
AIFunctionsSet >> functionNamed: functionName ifNone: noneBlock [

	^ self functions detect: [ :function | function name = functionName ] ifNone: noneBlock
]

{ #category : 'Not categorized' }
AIFunctionsSet >> functions [

	^ self allFunctions reject: [ :function | disabledFunctions includes: function ]
]

{ #category : 'Accessing' }
AIFunctionsSet >> functionsByCategory [

	| functionsByCategoryUnordered functionsByCategoryOrdered |

	functionsByCategoryUnordered := Dictionary new.
	self allFunctions do: [ :function |
		(functionsByCategoryUnordered at: function category ifAbsentPut: [ OrderedCollection new ])
			add: function ].
	functionsByCategoryOrdered := EsOrderedDictionary new.
	functionsByCategoryUnordered keys sorted do: [ :category |
		functionsByCategoryOrdered at: category put: (functionsByCategoryUnordered at: category) ].
	^ functionsByCategoryOrdered
]

{ #category : 'Not categorized' }
AIFunctionsSet >> initializeWithFunctions: initialAllFunctions [

	super initialize.
	allFunctions := initialAllFunctions.
	disabledFunctions := Set withAll: (allFunctions select: [ :function | function defaultEnabled not ]).
	functionsRequiringPermission := Set new.
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

{ #category : 'Not categorized' }
AIFunctionsSet >> removeFunction: function [

	allFunctions remove: function.
	disabledFunctions remove: function ifAbsent: [ ].
	functionsRequiringPermission remove: function ifAbsent: [ ].
]

{ #category : 'Not categorized' }
AIFunctionsSet >> requirePermissionToCallFunction: function [

	functionsRequiringPermission add: function.
	self changed: #functionsRequiringPermission.
]

{ #category : 'Not categorized' }
AIFunctionsSet >> requiresPermissionToCallFunction: function [

	^ functionsRequiringPermission includes: function
]
