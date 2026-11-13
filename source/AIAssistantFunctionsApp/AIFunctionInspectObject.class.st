Class {
	#name : 'AIFunctionInspectObject',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionInspectObject >> applyFunctionTo: arguments in: context [

	| objectHandle stringLimit indexedLimit object |

	objectHandle := arguments at: 'object_handle'.
	stringLimit := self printStringLimitFrom: arguments.
	indexedLimit := self indexedLimitFrom: arguments.

	object := context objectRegistry
		objectFor: objectHandle
		ifAbsent: [ ^ EsOrderedDictionary with: 'error' -> ('No object found with handle: ' , objectHandle asString) ].

	^ object
		aiJSONInContext: context
		stringsLimitedTo: stringLimit
		indexedLimitedTo: indexedLimit
]

{ #category : 'Accessing' }
AIFunctionInspectObject >> category [
	^ 'Testing & Debugging'
]

{ #category : 'Accessing' }
AIFunctionInspectObject >> description [
	^ 'Inspects a live object in memory using its object_handle, returning its class, object_handle, instance variables, and either its print string (plus class variables if inspecting a class) or its total size and elements (if inspecting a collection or a pointer variable class). Note that object_handle is not a unique identifier: the same object may be assigned different handles if the chat is saved and reopened or if its class definition changes.'
]

{ #category : 'Accessing' }
AIFunctionInspectObject >> name [
	^ 'inspect_object'
]

{ #category : 'Accessing' }
AIFunctionInspectObject >> parameters [
	^{ (AIFunctionParameterRequired
			name: 'object_handle'
			type: AIFunctionParameterTypeInteger new
			description: 'The handle of the object to inspect. Note that the same live object may receive different handles across saved/reopened chat sessions or after class shape changes.').
		(AIFunctionParameterOptional
			name: 'printstring_limit'
			type: AIFunctionParameterTypeInteger new
			description: 'The limit to use for the print string of variables, defaults to 200 and maxes out at 1000').
		(AIFunctionParameterOptional
			name: 'indexed_limit'
			type: AIFunctionParameterTypeInteger new
			description: 'The maximum number of indexed slots or elements to return for collections and variable classes, defaults to 50 and maxes out at 1000') }
]
