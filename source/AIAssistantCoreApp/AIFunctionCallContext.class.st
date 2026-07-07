Class {
	#name : 'AIFunctionCallContext',
	#superclass : 'Object',
	#instVars : [
		'model',
		'filePaths',
		'codeChanges'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionCallContext class >> model: model filePaths: filePaths codeChanges: codeChanges [

	^ self basicNew initializeWith: model filePaths: filePaths codeChanges: codeChanges
]

{ #category : 'Accessing' }
AIFunctionCallContext >> addRefactoryChange: change [

	codeChanges add: change
]

{ #category : 'Accessing' }
AIFunctionCallContext >> filePaths [

	^ filePaths
]

{ #category : 'Initialization' }
AIFunctionCallContext >> initializeWith: initialModel filePaths: initialFilePaths codeChanges: initialCodeChanges [

	self initialize.
	model := initialModel.
	filePaths := initialFilePaths.
	codeChanges := initialCodeChanges.
]

{ #category : 'Accessing' }
AIFunctionCallContext >> model [
	^model
]
