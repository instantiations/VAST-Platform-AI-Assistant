Class {
	#name : 'AIFunctionGetSuspendedProcessTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'testing' }
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

{ #category : 'testing' }
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

{ #category : 'testing' }
AIFunctionGetSuspendedProcessTest >> testGetSuspendedProcessWithSelectedSession [
	| result args originalDebugger mockDebugger mockSession process |
	originalDebugger := Processor debugger.
	mockDebugger := AIFunctionGetSuspendedProcessTestMockDebugger new.
	mockSession := AIFunctionGetSuspendedProcessTestMockSession new.
	process := [ Processor activeProcess suspend ] fork.
	[process isSuspended] whileFalse: [(Delay forMilliseconds: 10) wait].
	mockSession process: process.
	mockDebugger selectedSessions add: mockSession.
	
	[
		Processor debugger: mockDebugger.
		args := EsOrderedDictionary new.
		result := self applyFunction: AIFunctionGetSuspendedProcess withArguments: args.
	] ensure: [ 
		Processor debugger: originalDebugger.
		process terminate. 
	].
	
	self assert: (result includesKey: 'error') not.
	self assert: (result at: 'process_name') equals: 'Mock Process'.
	self assert: (result at: 'error_message') equals: 'Mock Error'.
	self assert: (result at: 'stack_trace') isCollection.
]
