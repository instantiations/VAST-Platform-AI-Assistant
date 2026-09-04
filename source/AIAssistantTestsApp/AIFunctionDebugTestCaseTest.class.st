Class {
	#name : 'AIFunctionDebugTestCaseTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Testing' }
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

{ #category : 'Testing' }
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

{ #category : 'Testing' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseInvalidClass [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseNonExistentClass'.
	args at: 'selector' put: 'testSomething'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test class provided.'
]

{ #category : 'Testing' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseInvalidSelector [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testNonExistent'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test selector provided.'
]

{ #category : 'Testing' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseNotATestClass [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'Object'.
	args at: 'selector' put: 'printString'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test class provided.'
]

{ #category : 'Testing' }
AIFunctionDebugTestCaseTest >> testDebugTestCaseNotATestSelector [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'printString'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid test selector provided.'
]

{ #category : 'Testing' }
AIFunctionDebugTestCaseTest >> testDebugTestCasePasses [
	| result args |
	args := EsOrderedDictionary new.
	args at: 'class_name' put: 'AIFunctionDebugTestCaseMockTest'.
	args at: 'selector' put: 'testPasses'.
	
	result := self applyFunction: AIFunctionDebugTestCase withArguments: args.
	
	self assert: (result at: 'status') equals: 'passed'.
	self assert: (result at: 'message') equals: 'Test passed successfully.'
]

{ #category : 'Testing' }
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

{ #category : 'Testing' }
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
