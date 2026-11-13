Class {
	#name : 'AIFunctionDebugTestCaseMockTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Testing' }
AIFunctionDebugTestCaseMockTest class >> isAbstract [
	^ true
]

{ #category : 'helpers' }
AIFunctionDebugTestCaseMockTest >> failingHelperWithArg: anArg [
	"Helper method with an argument and temporary variable that fails an assertion."

	| tempVar |
	tempVar := anArg , ' world'.
	self assert: false
]

{ #category : 'running' }
AIFunctionDebugTestCaseMockTest >> setUp [
	testSelector == #testSetUpErrors ifTrue: [ 1 / 0 ].
	super setUp
]

{ #category : 'running' }
AIFunctionDebugTestCaseMockTest >> tearDown [
	testSelector == #testTearDownErrors ifTrue: [ 1 / 0 ].
	super tearDown
]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testErrors [
	1 / 0
]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testFails [
	self assert: false
]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testFailsWithArgsAndTemps [
	"Simulate a failing test that calls a helper method with arguments and temporaries."

	self failingHelperWithArg: 'hello'
]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testHalts [
	"Simulate a test that halts explicitly using the Halt exception class."

	Halt signal: 'Explicit halt in test'
]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testPasses [
	self assert: true
]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testSetUpErrors [ ]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testTearDownErrors [ ]
