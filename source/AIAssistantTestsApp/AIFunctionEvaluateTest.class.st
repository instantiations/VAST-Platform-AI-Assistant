Class {
	#name : 'AIFunctionEvaluateTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateSignaledError [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> '1 / 0').
	self assert: result keys equals: (OrderedCollection with: 'error').
	self assert: (result at: 'error') equals: 'The evaluation signaled an error: Signal on Exception: (ExZeroDivide) A  divide-by-zero exception has occurred'.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testEvaluateSimpleExpression [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with:  'expression' -> '3 + 4').
	self assert: result keys equals: (OrderedCollection withAll: #('value_class' 'value_printstring' 'timetorun_ms')).
	self assert: (result at: 'value_class') equals: 'SmallInteger'.
	self assert: (result at: 'value_printstring') equals: '7'.
	self assert: (result at: 'timetorun_ms') >= 0.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringCustomLimit [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> 'String new: 100 withAll: $a' with: 'printstring_limit' -> 50).
	self assert: result keys equals: (OrderedCollection withAll: #('value_class' 'value_printstring' 'timetorun_ms')).
	self assert: (result at: 'value_printstring') equals: (String with: $') , (String new: 49 withAll: $a) , ' ...etc...'.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringDefaultLimit [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> 'String new: 3000 withAll: $a').
	self assert: result keys equals: (OrderedCollection withAll: #('value_class' 'value_printstring' 'timetorun_ms')).
	self assert: (result at: 'value_printstring') equals: (String with: $') , (String new: 1999 withAll: $a) , ' ...etc...'.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringMaxLimit [

	| result |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> 'String new: 105000 withAll: $a' with: 'printstring_limit' -> 200000).
	self assert: result keys equals: (OrderedCollection withAll: #('value_class' 'value_printstring' 'timetorun_ms')).
	self assert: (result at: 'value_printstring') equals: (String with: $') , (String new: 99999 withAll: $a) , ' ...etc...'.
]

{ #category : 'Tests' }
AIFunctionEvaluateTest >> testPrintStringNotTruncatedWhenWithinLimit [

	| result printString |

	result := self applyFunction: AIFunctionEvaluate withArguments: (EsOrderedDictionary with: 'expression' -> '''hello''').
	self assert: result keys equals: (OrderedCollection withAll: #('value_class' 'value_printstring' 'timetorun_ms')).
	printString := result at: 'value_printstring'.
	self assert: printString equals: '''hello'''
]
