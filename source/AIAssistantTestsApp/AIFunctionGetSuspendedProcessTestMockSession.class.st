Class {
	#name : 'AIFunctionGetSuspendedProcessTestMockSession',
	#superclass : 'Object',
	#instVars : [
		'process',
		'processName',
		'errorString',
		'firstVisibleFrame'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> errorString [
	^errorString ifNil: ['Mock Error']
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> errorString: aString [
	errorString := aString
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> firstVisibleFrame [
	^firstVisibleFrame ifNil: [1]
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> firstVisibleFrame: anInteger [
	firstVisibleFrame := anInteger
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> process [
	^process
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> process: aProcess [
	process := aProcess
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> processName [
	^processName ifNil: ['Mock Process']
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockSession >> processName: aString [
	processName := aString
]
