Class {
	#name : 'AIFunctionDebugTestCaseMockTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Testing' }
AIFunctionDebugTestCaseMockTest class >> isAbstract [
	^ true
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
AIFunctionDebugTestCaseMockTest >> testPasses [
	self assert: true
]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testSetUpErrors [ ]

{ #category : 'testing' }
AIFunctionDebugTestCaseMockTest >> testTearDownErrors [ ]
