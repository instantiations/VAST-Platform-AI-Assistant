Class {
	#name : 'AIFunctionsSet',
	#superclass : 'Object',
	#instVars : [
		'allFunctions',
		'disabledFunctions',
		'permissionRequiredPerFunction',
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

{ #category : 'Not categorized' }
AIFunctionsSet >> initialize [

	super initialize.
	(allFunctions := (AIAbstractFunction allSubclasses reject: [ :subclass | subclass isAbstract ]) collect: [ :subclass | subclass new ])
		sort: [ :function1 :function2 | function1 name < function2 name ].
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
