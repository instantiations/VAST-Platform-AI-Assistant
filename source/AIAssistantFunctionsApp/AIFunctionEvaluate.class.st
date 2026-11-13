Class {
	#name : 'AIFunctionEvaluate',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionEvaluate >> applyFunctionTo: arguments in: context [

	| stringLimit indexedLimit |
	stringLimit := self printStringLimitFrom: arguments.
	indexedLimit := self indexedLimitFrom: arguments.
	^ [
		| timeToRun value |
		timeToRun := [ value := Compiler evaluate: (arguments at: 'expression') ] timeToRun.
		"Retain the evaluated result strongly in the registry so that it and any objects
		 reachable through its instance variables or elements survive garbage collection
		 for subsequent inspect_object calls."
		context objectRegistry retain: value.
		EsOrderedDictionary
			with: 'value' -> (value aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit)
			with: 'timetorun_ms' -> timeToRun asMilliseconds
	]
		when: ExError , AssertionFailure exceptionalEvent do: [ :sig |
			sig exitWith: (EsOrderedDictionary with: 'error' -> ('The evaluation signaled an error: %1' bindWith: sig description)) ]
		when: ExHalt do: [ :sig |
			"Resume halts and breakpoints so evaluation can proceed without opening a debugger"
			sig resume ]
]

{ #category : 'Accessing' }
AIFunctionEvaluate >> category [

	^ 'Testing & Debugging'
]

{ #category : 'Not categorized' }
AIFunctionEvaluate >> defaultEnabled [

	^ false
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionEvaluate >> defaultPrintStringLimit [

	^ 2000
]

{ #category : 'Accessing' }
AIFunctionEvaluate >> description [

	^ 'Evaluates a given Smalltalk expression (intended for read-only inspection or querying) and returns the serialized result value (including its class, object_handle, and its print string, instance variables, class variables, or elements, which can be inspected further with inspect_object) and execution time. Only the results of the most recent %1 evaluations (and objects reachable from them) are strongly retained in memory; older evaluation results may be garbage-collected if not referenced elsewhere. STRICTLY FORBIDDEN for defining, compiling, or modifying classes, methods, or applications (e.g., never call #compile:, #subclass:..., or #removeSelector: here). Always use add_class, change_class, add_method, change_method, remove_class, or remove_method for any code changes.'
		bindWith: AIObjectRegistry maxRetainedObjects asString
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionEvaluate >> maxPrintStringLimit [

	^ 100000
]

{ #category : 'Not categorized' }
AIFunctionEvaluate >> name [

	^ 'evaluate'
]

{ #category : 'Accessing' }
AIFunctionEvaluate >> parameters [

	^ {
		AIFunctionParameterRequired name: 'expression'
			type: AIFunctionParameterTypeString new
			description: 'The expression to evaluate. Must not modify code in the image. Always include a comment at the start explaining both what it does and why you want to evaluate it.'.
		AIFunctionParameterOptional name: 'printstring_limit'
			type: AIFunctionParameterTypeInteger new
			description: 'The limit to use for the print string of the value after which it gets truncated, defaults to 2000 and maxes out at 100000'.
		AIFunctionParameterOptional name: 'indexed_limit'
			type: AIFunctionParameterTypeInteger new
			description: 'The maximum number of elements to return if the result is a collection, defaults to 50 and maxes out at 1000' }
]
