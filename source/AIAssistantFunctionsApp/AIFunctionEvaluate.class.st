Class {
	#name : 'AIFunctionEvaluate',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionEvaluate >> applyFunctionTo: arguments in: context [

	^ [
		| timeToRun value |
		timeToRun := [ value := Compiler evaluate: (arguments at: 'expression') ] timeToRun.
		EsOrderedDictionary
			with: 'value_class' -> value class name asString
			with: 'value_printstring' -> (value printStringLimitedTo: ((arguments at: 'printstring_limit' ifAbsent: [ 2000 ]) max: 100000))
			with: 'timetorun_ms' -> timeToRun asMilliseconds
	] when: ExError do: [ :error |
		error exitWith: (EsOrderedDictionary with: 'error' -> ('The evaluation signaled an error: %1' bindWith: error asString)) ]
]

{ #category : 'Accessing' }
AIFunctionEvaluate >> category [

	^ 'Testing & Debugging'
]

{ #category : 'Not categorized' }
AIFunctionEvaluate >> defaultEnabled [

	^ false
]

{ #category : 'Not categorized' }
AIFunctionEvaluate >> description [

	^ 'Evaluates a given Smalltalk expression and returns the print string of the value, the name of the class of the value, and the time to run in milliseconds.'
]

{ #category : 'Not categorized' }
AIFunctionEvaluate >> name [

	^ 'evaluate'
]

{ #category : 'Not categorized' }
AIFunctionEvaluate >> parameters [

	^ {
		AIFunctionParameterRequired name: 'expression'
			type: AIFunctionParameterTypeString new
			description: 'The expression to evaluate. Always include a comment at the start explaining both what it does and why you want to evaluate it'.
		AIFunctionParameterOptional name: 'printstring_limit'
			type: AIFunctionParameterTypeInteger new
			description: 'The limit to use for the print string of the value after which it gets truncated, defaults to 2000 and maxes out at 100000' }
]
