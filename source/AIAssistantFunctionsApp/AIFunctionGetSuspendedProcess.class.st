Class {
	#name : 'AIFunctionGetSuspendedProcess',
	#superclass : 'AIAbstractStackIterationFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionGetSuspendedProcess >> applyFunctionTo: arguments in: context [

	| debugger session frames |

	debugger := Processor debugger.
	debugger ifNil: [^EsOrderedDictionary with: 'error' -> 'No debugger is currently open.'].
	debugger selectedSessions ifEmpty: [
		^EsOrderedDictionary with: 'error' -> 'No process is currently selected in the debugger.'].

	session :=  debugger selectedSessions first.
	frames := self stackFramesJSONFrom: session process topFrame arguments: arguments.

	^EsOrderedDictionary new
		at: 'process_name' put: session processName;
		at: 'error_message' put: session errorString;
		at: 'stack_trace' put: frames;
		yourself
]

{ #category : 'Accessing' }
AIFunctionGetSuspendedProcess >> category [

	^ 'Testing & Debugging'
]

{ #category : 'Accessing' }
AIFunctionGetSuspendedProcess >> description [
	^ 'Gets information about the process that is currently suspended and selected in the debugger, including its error message, and a detailed stack trace with each frame containing its signature, receiver, arguments, and temporary variables.'
]

{ #category : 'Accessing' }
AIFunctionGetSuspendedProcess >> name [
	^ 'get_suspended_process'
]
