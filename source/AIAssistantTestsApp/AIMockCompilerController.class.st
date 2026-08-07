Class {
	#name : 'AIMockCompilerController',
	#superclass : 'Object',
	#instVars : [
		'errorReported'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'accessing' }
AIMockCompilerController >> compilerError: anError [
	errorReported := anError
]

{ #category : 'accessing' }
AIMockCompilerController >> errorReported [
	^errorReported
]
