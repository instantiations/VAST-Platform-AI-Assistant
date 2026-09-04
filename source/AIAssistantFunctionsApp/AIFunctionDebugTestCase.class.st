Class {
	#name : 'AIFunctionDebugTestCase',
	#superclass : 'AIAbstractStackIterationFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionDebugTestCase >> applyFunctionTo: arguments in: context [

	| className selector testClass testCase process semaphore frames errorMsg errorClass exceptionCaught |

	className := arguments at: 'class_name'.
	selector := arguments at: 'selector'.

	testClass := self classNamed: className.
	(testClass isNil or: [(testClass inheritsFrom: TestCase) not])
		ifTrue: [^EsOrderedDictionary with: 'error' -> 'Invalid test class provided.'].

	(testClass allTestSelectors includes: selector asSymbol)
		ifFalse: [^EsOrderedDictionary with: 'error' -> 'Invalid test selector provided.'].

	testCase := testClass selector: selector asSymbol.
	semaphore := Semaphore new.
	exceptionCaught := false.

	"Run the test in a separate process so we can easily suspend it on error to capture the stack"
	[
		process :=
			[
				[
					testCase runCase.
					semaphore signal]
						on: TestResult failure , TestResult error , Halt
						do: [:ex |
							exceptionCaught := true.
							errorMsg := ex description.
							errorClass := ex class name asString.
							semaphore signal.
							Processor activeProcess suspend]]
								fork.

		"Wait until the test finishes or an exception is caught"
		semaphore wait.

		"Wait for the process to actually suspend if it failed"
		[process isSuspended or: [process isDead]] whileFalse: [(Delay forMilliseconds: 10) wait].

		"Collect the preserved stack frames exactly as a Debugger Session does"
		frames :=
			process isSuspended
				ifTrue: [
					| firstFrame stopMethods |
					firstFrame := self findFirstVisibleFrameFrom: process topFrame.
					stopMethods := {
						testClass lookupSelector: selector asSymbol.
						testClass lookupSelector: #setUp.
						testClass lookupSelector: #tearDown
					} reject: [:each | each isNil].
					self
						stackFramesJSONFrom: firstFrame
						arguments: arguments
						until: [:frame | frame isExecutingBlock not and: [stopMethods includes: frame method]]]
				ifFalse: [#()]]
					ensure: [process terminate].

	exceptionCaught ifFalse: [
		^EsOrderedDictionary new
			at: 'status' put: 'passed';
			at: 'message' put: 'Test passed successfully.';
			yourself].

	^EsOrderedDictionary new
		at: 'process_name' put: (className , '>>' , selector);
		at: 'error_message' put: errorMsg;
		at: 'exception_class' put: errorClass;
		at: 'stack_trace' put: frames;
		yourself
]

{ #category : 'Accessing' }
AIFunctionDebugTestCase >> category [

	^ 'Testing & Debugging'
]

{ #category : 'Accessing' }
AIFunctionDebugTestCase >> description [

	^ 'Runs a single SUnit test case in debug mode and returns its stacktrace if it fails or errors, similar to investigating an open debugger.'
]

{ #category : 'Internal' }
AIFunctionDebugTestCase >> findFirstVisibleFrameFrom: topFrame [

	| current |

	current := topFrame.
	[current notNil and: [current method selector ~= #applyFunctionTo:in:]]
		whileTrue: [current := current previousFrame].
	^current ifNotNil: [current previousFrame]
]

{ #category : 'Accessing' }
AIFunctionDebugTestCase >> name [

	^ 'debug_test_case'
]

{ #category : 'Accessing' }
AIFunctionDebugTestCase >> parameters [

	^{
		AIFunctionParameterRequired
			name: 'class_name'
			type: AIFunctionParameterTypeString new
			description: 'Name of the test class'.
		AIFunctionParameterRequired
			name: 'selector'
			type: AIFunctionParameterTypeString new
			description: 'Name of the test selector/method' } , super parameters
]
