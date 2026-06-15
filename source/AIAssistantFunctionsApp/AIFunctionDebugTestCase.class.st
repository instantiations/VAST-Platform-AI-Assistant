Class {
	#name : 'AIFunctionDebugTestCase',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionDebugTestCase >> applyFunctionTo: arguments in: context [
	| className selector testClass testCase process semaphore frames errorMsg errorClass |
	
	className := arguments at: 'class_name'.
	selector := arguments at: 'selector'.
	
	testClass := Smalltalk at: className asSymbol ifAbsent: [ nil ].
	(testClass isNil or: [ (testClass inheritsFrom: TestCase) not ]) ifTrue: [
		^ EsOrderedDictionary with: 'error' -> 'Invalid test class provided.'
	].

	testCase := testClass selector: selector asSymbol.

	semaphore := Semaphore new.

	"Run the test in a separate process so we can easily suspend it on error to capture the stack"
	process := [
		[ testCase runCase. semaphore signal ] 
			on: TestResult failure, TestResult error, Halt 
			do: [ :ex | 
				errorMsg := ex description.
				errorClass := ex class name.
				semaphore signal.
				Processor activeProcess suspend.
			].
	] fork.

	"Wait until the test finishes or an exception is caught"
	semaphore wait.
	
	"Wait for the process to actually suspend if it failed"
	[ process isSuspended or: [ process isDead ] ] whileFalse: [ (Delay forMilliseconds: 10) wait ].
	
	"Collect the preserved stack frames exactly as a Debugger Session does"
	frames := process isSuspended 
		ifTrue: [ process allFrames collect: [ :frame | frame printString ] ] 
		ifFalse: [ #() ].
		
	process terminate.

	errorMsg ifNil: [
		^ EsOrderedDictionary new
			at: 'status' put: 'passed';
			at: 'message' put: 'Test passed successfully.';
			yourself
	].

	^ EsOrderedDictionary new
		at: 'process_name' put: (className , '>>' , selector);
		at: 'error_message' put: errorMsg;
		at: 'exception_class' put: errorClass;
		at: 'stack_trace' put: frames;
		yourself
]

{ #category : 'Accessing' }
AIFunctionDebugTestCase >> description [

	^ 'Runs a single SUnit test case in debug mode and returns its stacktrace if it fails or errors, similar to investigating an open debugger.'
]

{ #category : 'Accessing' }
AIFunctionDebugTestCase >> name [

	^ 'debug_test_case'
]

{ #category : 'Accessing' }
AIFunctionDebugTestCase >> parameters [

	^ {
		AIFunctionParameterRequired name: 'class_name'
			type: AIFunctionParameterTypeString new
			description: 'Name of the test class'.
		AIFunctionParameterRequired name: 'selector'
			type: AIFunctionParameterTypeString new
			description: 'Name of the test selector/method' }
]
