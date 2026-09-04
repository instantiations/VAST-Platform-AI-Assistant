Class {
	#name : 'AIFunctionGetSuspendedProcessTestMockDebugger',
	#superclass : 'Object',
	#instVars : [
		'selectedSessions'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockDebugger >> selectedSessions [
	^selectedSessions ifNil: [selectedSessions := OrderedCollection new]
]

{ #category : 'accessing' }
AIFunctionGetSuspendedProcessTestMockDebugger >> selectedSessions: aCollection [
	selectedSessions := aCollection
]
