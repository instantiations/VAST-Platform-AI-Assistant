Class {
	#name : 'GeminiFunctionCallContext',
	#superclass : 'Object',
	#instVars : [
		'filePaths'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionCallContext class >> filePaths: filePaths [

	^ self basicNew initializeWithFilePaths: filePaths
]

{ #category : 'Not categorized' }
GeminiFunctionCallContext >> filePaths [

	^ filePaths
]

{ #category : 'Not categorized' }
GeminiFunctionCallContext >> initializeWithFilePaths: initialFilePaths [

	self initialize.
	filePaths := initialFilePaths.
]
