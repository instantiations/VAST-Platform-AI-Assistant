Class {
	#name : 'AIFunctionDebugTestCaseTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseErrors [
	| result args stackTrace firstFrame lastFrame |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testErrors'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'status') not.
	self assert: (result at: 'process_name') equals: 'AIFunctionDebugTestCaseMockTest>>testErrors'.
	self assert: (result at: 'exception_class') equals: 'ZeroDivide'.
	
	stackTrace := result at: 'stack_trace'.
	self assert: stackTrace size > 0.
	
	firstFrame := stackTrace first.
	self assert: (firstFrame at: 'signature') equals: 'ZeroDivide(Exception)>>#evaluate:'.
	
	lastFrame := stackTrace last.
	self assert: (lastFrame at: 'signature') equals: 'AIFunctionDebugTestCaseMockTest>>#testErrors'.
	self assert: (stackTrace noneSatisfy: [:frame | ((frame at: 'signature') includesSubstring: 'applyFunctionTo:in:') ])
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseFails [
	| result args stackTrace firstFrame lastFrame |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testFails'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'status') not.
	self assert: (result at: 'process_name') equals: 'AIFunctionDebugTestCaseMockTest>>testFails'.
	self assert: (result at: 'exception_class') equals: 'TestFailure'.
	
	stackTrace := result at: 'stack_trace'.
	self assert: stackTrace size > 0.
	
	firstFrame := stackTrace first.
	self assert: (firstFrame at: 'signature') equals: 'TestFailure(Exception)>>#evaluate:'.
	
	lastFrame := stackTrace last.
	self assert: (lastFrame at: 'signature') equals: 'AIFunctionDebugTestCaseMockTest>>#testFails'.
	self assert: (stackTrace noneSatisfy: [:frame | (frame at: 'signature') includesSubstring: 'applyFunctionTo:in:' ])
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseHalts [
	| result args stackTrace lastFrame |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testHalts'.

	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.

	self assert: (result includesKey: 'status') not.
	self assert: (result at: 'process_name') equals: 'AIFunctionDebugTestCaseMockTest>>testHalts'.
	self assert: (result at: 'exception_class') equals: 'Halt'.
	self assert: ((result at: 'error_message') includesSubstring: 'Explicit halt in test').

	stackTrace := result at: 'stack_trace'.
	self assert: stackTrace notEmpty.
	lastFrame := stackTrace last.
	self assert: (lastFrame at: 'signature') equals: 'AIFunctionDebugTestCaseMockTest>>#testHalts'
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseInvalidClass [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseNonExistentClass'.
	args at: 'selector' put: 'testSomething'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test class provided.'
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseInvalidSelector [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testNonExistent'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test selector provided.'
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseNotATestClass [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'Object'.
	args at: 'selector' put: 'printString'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test class provided.'
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseNotATestSelector [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'printString'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test selector provided.'
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCasePasses [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testPasses'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result at: 'status') equals: 'passed'.
	self assert: (result at: 'message') equals: 'Test passed successfully.'
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseSetUpErrors [
	| result args stackTrace firstFrame lastFrame |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testSetUpErrors'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'status') not.
	self assert: (result at: 'process_name') equals: 'AIFunctionDebugTestCaseMockTest>>testSetUpErrors'.
	self assert: (result at: 'exception_class') equals: 'ZeroDivide'.
	
	stackTrace := result at: 'stack_trace'.
	self assert: stackTrace size > 0.
	
	firstFrame := stackTrace first.
	self assert: (firstFrame at: 'signature') equals: 'ZeroDivide(Exception)>>#evaluate:'.
	
	lastFrame := stackTrace last.
	self assert: (lastFrame at: 'signature') equals: 'AIFunctionDebugTestCaseMockTest>>#setUp'.
	self assert: (stackTrace noneSatisfy: [:frame | (frame at: 'signature') includesSubstring: 'applyFunctionTo:in:' ])
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseStackFrameReceiverArgumentsAndTemporaries [
	| context result args stackTrace helperFrame receiver arguments temporaries |
	context := self emptyContext.
	args := EsOrderedDictionary
		with: 'class_name' -> 'AIFunctionDebugTestCaseMockTest'
		with: 'selector' -> 'testFailsWithArgsAndTemps'
		with: 'printstring_limit' -> 10.

	result := self applyFunction: AIFunctionDebugTestCase withArguments: args inContext: context.
	stackTrace := result at: 'stack_trace'.

	helperFrame := stackTrace
		detect: [ :frame | (frame at: 'signature') = 'AIFunctionDebugTestCaseMockTest>>#failingHelperWithArg:' ]
		ifNone: [ self fail: 'Expected failingHelperWithArg: frame in stack trace' ].

	receiver := helperFrame at: 'receiver'.
	self assert: (receiver at: 'class') equals: 'AIFunctionDebugTestCaseMockTest'.
	self assert: (receiver includesKey: 'object_handle').

	arguments := helperFrame at: 'arguments'.
	self assert: (arguments includesKey: 'anArg').
	self assert: ((arguments at: 'anArg') at: 'class') equals: 'String'.
	self assert: ((arguments at: 'anArg') at: 'print_string') equals: '''hello'''.

	temporaries := helperFrame at: 'temporaries'.
	self assert: (temporaries includesKey: 'tempVar').
	self assert: ((temporaries at: 'tempVar') at: 'class') equals: 'String'.
	self assert: ((temporaries at: 'tempVar') at: 'print_string') equals: ('hello world' printStringLimitedTo: 10)
]

{ #category : 'Tests' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseTearDownErrors [
	| result args stackTrace firstFrame lastFrame |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testTearDownErrors'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'status') not.
	self assert: (result at: 'process_name') equals: 'AIFunctionDebugTestCaseMockTest>>testTearDownErrors'.
	self assert: (result at: 'exception_class') equals: 'ZeroDivide'.
	
	stackTrace := result at: 'stack_trace'.
	self assert: stackTrace size > 0.
	
	firstFrame := stackTrace first.
	self assert: (firstFrame at: 'signature') equals: 'ZeroDivide(Exception)>>#evaluate:'.
	
	lastFrame := stackTrace last.
	self assert: (lastFrame at: 'signature') equals: 'AIFunctionDebugTestCaseMockTest>>#tearDown'.
	self assert: (stackTrace noneSatisfy: [:frame | (frame at: 'signature') includesSubstring: 'applyFunctionTo:in:' ])
]
