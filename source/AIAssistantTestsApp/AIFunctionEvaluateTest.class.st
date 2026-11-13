Class {
	#name : 'AIFunctionEvaluateTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateAssertionFailureIsCaught [
	"Verify that an AssertionFailure (which is a subclass of Halt in VAST) is treated
	 as an evaluation error rather than resumed."

	| result |

	result := self
		applyFunction: AIFunctionEvaluate
		withArguments: (EsOrderedDictionary with: 'expression' -> 'self assert: [ false ] description: ''Custom assertion failure''. 3 + 4').
	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'error' -> 'The evaluation signaled an error: (ExAssertionFailure) An exception has occurred: Custom assertion failure')
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateCollectionWithIndexedLimitAndInspect [

	| context result expectedInstVars inspectResult |

	context := self emptyContext.
	result := self
		applyFunction: AIFunctionEvaluate
		withArguments: (EsOrderedDictionary
			with: 'expression' -> '(1 to: 10) asOrderedCollection'
			with: 'indexed_limit' -> 3)
		inContext: context.

	expectedInstVars := EsOrderedDictionary
		with: 'elements' -> (EsOrderedDictionary
			with: 'class' -> 'Array'
			with: 'print_string' -> '(1 2 3 4 5 6 7 8 9 10)'
			with: 'object_handle' -> 2)
		with: 'firstIndex' -> (EsOrderedDictionary
			with: 'class' -> 'SmallInteger'
			with: 'print_string' -> '0'
			with: 'object_handle' -> 3)
		with: 'lastIndex' -> (EsOrderedDictionary
			with: 'class' -> 'SmallInteger'
			with: 'print_string' -> '10'
			with: 'object_handle' -> 4).

	self
		assert: (result at: 'value')
		equals: (EsOrderedDictionary
			with: 'class' -> 'OrderedCollection'
			with: 'object_handle' -> 1
			with: 'size' -> 10
			with: 'instance_variables' -> expectedInstVars
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '1'
					with: 'object_handle' -> 5)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '2'
					with: 'object_handle' -> 6)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '3'
					with: 'object_handle' -> 7))).

	inspectResult := self
		applyFunction: AIFunctionInspectObject
		withArguments: (EsOrderedDictionary
			with: 'object_handle' -> 1
			with: 'indexed_limit' -> 5)
		inContext: context.

	self
		assert: inspectResult
		equals: (EsOrderedDictionary
			with: 'class' -> 'OrderedCollection'
			with: 'object_handle' -> 1
			with: 'size' -> 10
			with: 'instance_variables' -> expectedInstVars
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '1'
					with: 'object_handle' -> 5)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '2'
					with: 'object_handle' -> 6)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '3'
					with: 'object_handle' -> 7)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '4'
					with: 'object_handle' -> 8)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '5'
					with: 'object_handle' -> 9)))
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateHaltIsResumed [
	"Verify that both instance-based (self halt:) and class-based (Halt signal:) halts
	 are resumed during evaluation so the expression completes and returns its result."

	| result valueResult |

	result := self
		applyFunction: AIFunctionEvaluate
		withArguments: (EsOrderedDictionary with: 'expression' -> 'self halt: ''Test halt''. Halt signal: ''Class halt''. 3 + 4').
	self assert: result keys equals: (OrderedCollection withAll: #('value' 'timetorun_ms')).
	valueResult := result at: 'value'.
	self assert: (valueResult at: 'class') equals: 'SmallInteger'.
	self assert: (valueResult at: 'print_string') equals: '7'
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateResultAndReachableObjectsSurviveGarbageCollection [
	"Verify that the result of an evaluation and objects reachable from its instance variables
	 are strongly retained by the object registry and can still be inspected after a garbage collection."

	| context evalResult valueJSON rootHandle childHandle inspectRootResult inspectChildResult |
	context := self emptyContext.
	evalResult := self
		applyFunction: AIFunctionEvaluate
		withArguments: (EsOrderedDictionary
			with: 'expression' -> 'AIJSONMockClass new var1: (Point x: 7 y: 8); yourself')
		inContext: context.

	valueJSON := evalResult at: 'value'.
	rootHandle := valueJSON at: 'object_handle'.
	childHandle := ((valueJSON at: 'instance_variables') at: 'var1') at: 'object_handle'.

	System globalGarbageCollect.
	[ Processor finalizeCycle ] whileTrue: [].

	inspectRootResult := self
		applyFunction: AIFunctionInspectObject
		withArguments: (EsOrderedDictionary with: 'object_handle' -> rootHandle)
		inContext: context.
	self assert: (inspectRootResult includesKey: 'error') not.
	self assert: (inspectRootResult at: 'class') equals: 'AIJSONMockClass'.

	inspectChildResult := self
		applyFunction: AIFunctionInspectObject
		withArguments: (EsOrderedDictionary with: 'object_handle' -> childHandle)
		inContext: context.
	self
		assert: inspectChildResult
		equals: (EsOrderedDictionary
			with: 'class' -> 'Point'
			with: 'print_string' -> '7 @ 8'
			with: 'object_handle' -> childHandle
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'x' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '7'
					with: 'object_handle' -> 3)
				with: 'y' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '8'
					with: 'object_handle' -> 4)))
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateSignaledError [
	"Verify that an Error signaled during evaluation is caught and returned as an error dictionary."

	| result errorText |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> '1 / 0').
	self assert: result keys equals: (OrderedCollection with: 'error').
	self assert: (result at: 'error') equals: 'The evaluation signaled an error: (ExZeroDivide) A  divide-by-zero exception has occurred'.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateSimpleExpression [

	| result valueresult |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with:  'expression' -> '3 + 4').
	self assert: result keys equals: (OrderedCollection withAll: #('value' 'timetorun_ms')).
	valueresult := result at: 'value'.
	self assert: (valueresult at: 'class') equals: 'SmallInteger'.
	self assert: (valueresult at: 'print_string') equals: '7'.
	self assert: (valueresult includesKey: 'object_handle').
	self assert: (valueresult at: 'instance_variables') equals: EsOrderedDictionary new.
	self assert: (result at: 'timetorun_ms') >= 0.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringCustomLimit [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> 'String new: 100 withAll: $a' with: 'printstring_limit' -> 50).
	self assert: result keys equals: (OrderedCollection withAll: #('value' 'timetorun_ms')).
	self assert: ((result at: 'value') at: 'print_string') equals: ((String new: 100 withAll: $a) printStringLimitedTo: 50).
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringDefaultLimit [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> 'String new: 3000 withAll: $a').
	self assert: result keys equals: (OrderedCollection withAll: #('value' 'timetorun_ms')).
	self assert: ((result at: 'value') at: 'print_string') equals: '''',(String new: 1999 withAll: $a) ,' ...etc...'.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringMaxLimit [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> 'String new: 105000 withAll: $a' with: 'printstring_limit' -> 200000).
	self assert: result keys equals: (OrderedCollection withAll: #('value' 'timetorun_ms')).
	self assert: ((result at: 'value') at: 'print_string') equals: '''',(String new: 99999 withAll: $a) ,' ...etc...'.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringNotTruncatedWhenWithinLimit [

	| result printString |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> '''hello''').
	self assert: result keys equals: (OrderedCollection withAll: #('value' 'timetorun_ms')).
	printString := (result at: 'value') at: 'print_string'.
	self assert: printString equals: '''hello'''
]
