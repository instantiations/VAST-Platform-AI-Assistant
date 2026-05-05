Class {
	#name : 'AIFunctionCallContext',
	#superclass : 'Object',
	#instVars : [
		'model',
		'filePaths'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionCallContext class >> filePaths: filePaths [

	^ self basicNew initializeWithFilePaths: filePaths
]

{ #category : 'Not categorized' }
AIFunctionCallContext class >> model: aModel filePaths: filePaths [

	^ self basicNew initialize: aModel withFilePaths: filePaths
]

{ #category : 'Accessing' }
AIFunctionCallContext >> filePaths [

	^ filePaths
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIFunctionCallContext >> initialize: aModel withFilePaths: initialFilePaths [

	self initialize.
	model := aModel.
	filePaths := initialFilePaths.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIFunctionCallContext >> initializeWithFilePaths: initialFilePaths [

	self initialize.
	filePaths := initialFilePaths.
]

{ #category : 'Accessing' }
AIFunctionCallContext >> model [
	^model
]
