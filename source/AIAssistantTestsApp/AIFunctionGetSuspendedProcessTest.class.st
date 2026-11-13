Class {
	#name : 'AIFunctionGetSuspendedProcessTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionGetSuspendedProcessTest >> testGetSuspendedProcessNoDebugger [
	| result args originalDebugger |
	originalDebugger := Processor debugger.
	[
		Processor debugger: nil.
		args := EsOrderedDictionary new.
		result := self applyFunction: AIFunctionGetSuspendedProcess withArguments: args.
	] ensure: [ Processor debugger: originalDebugger ].
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'No debugger is currently open.'
]

{ #category : 'Tests' }
AIFunctionGetSuspendedProcessTest >> testGetSuspendedProcessNoSelectedSession [
	| result args originalDebugger mockDebugger |
	originalDebugger := Processor debugger.
	mockDebugger := AIFunctionGetSuspendedProcessTestMockDebugger new.
	[
		Processor debugger: mockDebugger.
		args := EsOrderedDictionary new.
		result := self applyFunction: AIFunctionGetSuspendedProcess withArguments: args.
	] ensure: [ Processor debugger: originalDebugger ].
	
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'No process is currently selected in the debugger.'
]

{ #category : 'Tests' }
AIFunctionGetSuspendedProcessTest >> testGetSuspendedProcessStackSizeAndPrintStringLimits [
	"Verify that stacksize_limit and printstring_limit are respected by get_suspended_process."

	| context result args originalDebugger mockDebugger mockSession process longString stackTrace targetFrame |
	context := self emptyContext.
	originalDebugger := Processor debugger.
	mockDebugger := AIFunctionGetSuspendedProcessTestMockDebugger new.
	mockSession := AIFunctionGetSuspendedProcessTestMockSession new.
	longString := String new: 100 withAll: $s.
	process := [
		[ :argStr |
			Processor activeProcess suspend.
			argStr ] value: longString ] fork.
	[ process isSuspended ] whileFalse: [ (Delay forMilliseconds: 10) wait ].
	mockSession process: process.
	mockDebugger selectedSessions add: mockSession.

	[
		Processor debugger: mockDebugger.
		args := EsOrderedDictionary
			with: 'stacksize_limit' -> 3
			with: 'printstring_limit' -> 10.
		result := self applyFunction: AIFunctionGetSuspendedProcess withArguments: args inContext: context.
	] ensure: [
		Processor debugger: originalDebugger.
		process terminate.
	].

	stackTrace := result at: 'stack_trace'.
	self assert: stackTrace size equals: 3.

	targetFrame := stackTrace
		detect: [ :f | (f at: 'arguments') includesKey: 'argStr' ]
		ifNone: [ self fail: 'Expected frame with argStr argument' ].
	self
		assert: (((targetFrame at: 'arguments') at: 'argStr') at: 'print_string')
		equals: (longString printStringLimitedTo: 10)
]

{ #category : 'Tests' }
AIFunctionGetSuspendedProcessTest >> testGetSuspendedProcessWithSelectedSession [
	"Verify that get_suspended_process returns the process name, error message,
	 and serialized stack frames with signature, receiver, arguments, and temporaries."

	| context result args originalDebugger mockDebugger mockSession process stackTrace firstFrame |
	context := self emptyContext.
	originalDebugger := Processor debugger.
	mockDebugger := AIFunctionGetSuspendedProcessTestMockDebugger new.
	mockSession := AIFunctionGetSuspendedProcessTestMockSession new.
	process := [ Processor activeProcess suspend ] fork.
	[ process isSuspended ] whileFalse: [ (Delay forMilliseconds: 10) wait ].
	mockSession process: process.
	mockDebugger selectedSessions add: mockSession.

	[
		[
			Processor debugger: mockDebugger.
			args := EsOrderedDictionary new.
			result := self applyFunction: AIFunctionGetSuspendedProcess withArguments: args inContext: context.
		] ensure: [
			Processor debugger: originalDebugger ].

		self assert: (result includesKey: 'error') not.
		self assert: (result at: 'process_name') equals: 'Mock Process'.
		self assert: (result at: 'error_message') equals: 'Mock Error'.

		stackTrace := result at: 'stack_trace'.
		self assert: stackTrace isCollection.
		self assert: stackTrace notEmpty.

		firstFrame := stackTrace first.
		self
			assert: firstFrame
			equals: (EsOrderedDictionary
				with: 'signature' -> 'ProcessorScheduler>>#suspend:'
				with: 'receiver' -> (EsOrderedDictionary
					with: 'class' -> 'ProcessorScheduler'
					with: 'print_string' -> 'a ProcessorScheduler'
					with: 'object_handle' -> 1)
				with: 'arguments' -> (EsOrderedDictionary
					with: 'aProcess' -> (EsOrderedDictionary
						with: 'class' -> 'Process'
						with: 'print_string' -> process printString
						with: 'object_handle' -> 2))
				with: 'temporaries' -> (EsOrderedDictionary
					with: 'state' -> (EsOrderedDictionary
						with: 'class' -> 'True'
						with: 'print_string' -> 'true'
						with: 'object_handle' -> 3)))
	] ensure: [ process terminate ]
]
