Class {
	#name : 'AIFunctionGetSuspendedProcess',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionGetSuspendedProcess >> applyFunctionTo: arguments in: context [

	| debugger session frames |
	debugger := Processor debugger.
	debugger ifNil: [ 
		^ EsOrderedDictionary with: 'error' -> 'No debugger is currently open.' ].
	
	session := debugger selectedSessions 
		ifEmpty: [ nil ] 
		ifNotEmpty: [ :sessions | sessions first ].
	session ifNil: [ 
		^ EsOrderedDictionary with: 'error' -> 'No process is currently selected in the debugger.' ].
	
	frames := session visibleStackFrames collect: [ :frame | frame printString ].
	
	^ EsOrderedDictionary new
		at: 'process_name' put: session processName;
		at: 'error_message' put: session errorString;
		at: 'stack_trace' put: frames;
		yourself
]

{ #category : 'Not categorized' }
AIFunctionGetSuspendedProcess >> description [
	^ 'Gets information about the process that is currently suspended and selected in the debugger, including its error message and stack trace.'
]

{ #category : 'Not categorized' }
AIFunctionGetSuspendedProcess >> name [
	^ 'get_suspended_process'
]

{ #category : 'Not categorized' }
AIFunctionGetSuspendedProcess >> parameters [
	^ #()
]
