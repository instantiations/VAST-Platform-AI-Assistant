Class {
	#name : 'GeminiFunctionGetSuspendedProcess',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetSuspendedProcess >> applyFunctionTo: arguments in: context [

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
GeminiFunctionGetSuspendedProcess >> description [
	^ 'Gets information about the process that is currently suspended and selected in the debugger, including its error message and stack trace.'
]

{ #category : 'Not categorized' }
GeminiFunctionGetSuspendedProcess >> name [
	^ 'get_suspended_process'
]

{ #category : 'Not categorized' }
GeminiFunctionGetSuspendedProcess >> parameters [
	^ #()
]
