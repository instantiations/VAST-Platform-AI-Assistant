Class {
	#name : 'AIRemoveMethodChange',
	#superclass : 'RemoveMethodChange',
	#instVars : [
		'application'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'instance creation' }
AIRemoveMethodChange class >> remove: aSymbol from: aClass application: anApplication [
	^(self new)
		changeClass: aClass;
		selector: aSymbol;
		application: anApplication;
		yourself
]

{ #category : 'accessing' }
AIRemoveMethodChange >> application [
	^application
]

{ #category : 'accessing' }
AIRemoveMethodChange >> application: anApplication [
	application := anApplication
]

{ #category : 'accessing' }
AIRemoveMethodChange >> isMethodChange [
	^true
]
