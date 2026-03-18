Class {
	#name : 'GeminiFunctionCallContext',
	#superclass : 'Object',
	#instVars : [
		'model',
		'filePaths'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionCallContext class >> filePaths: filePaths [

	^ self basicNew initializeWithFilePaths: filePaths
]

{ #category : 'Not categorized' }
GeminiFunctionCallContext class >> model: aModel filePaths: filePaths [

	^ self basicNew initialize: aModel withFilePaths: filePaths
]

{ #category : 'Accessing' }
GeminiFunctionCallContext >> filePaths [

	^ filePaths
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
GeminiFunctionCallContext >> initialize: aModel withFilePaths: initialFilePaths [

	self initialize.
	model := aModel.
	filePaths := initialFilePaths.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
GeminiFunctionCallContext >> initializeWithFilePaths: initialFilePaths [

	self initialize.
	filePaths := initialFilePaths.
]

{ #category : 'Accessing' }
GeminiFunctionCallContext >> model [
	^model
]
