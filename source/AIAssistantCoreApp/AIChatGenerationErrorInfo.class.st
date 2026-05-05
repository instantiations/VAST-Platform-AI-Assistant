Class {
	#name : 'AIChatGenerationErrorInfo',
	#superclass : 'Object',
	#instVars : [
		'error',
		'generator'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGenerationErrorInfo class >> forError: anError withGenerator: generator [

	^ self new initializeForError: anError withGenerator: generator
]

{ #category : 'Not categorized' }
AIChatGenerationErrorInfo >> description [

	^ error description


]

{ #category : 'Not categorized' }
AIChatGenerationErrorInfo >> error  [

	^ error
]

{ #category : 'Not categorized' }
AIChatGenerationErrorInfo >> initializeForError: initialError withGenerator: initialGenerator [

	error := initialError.
	generator := initialGenerator
]

{ #category : 'Not categorized' }
AIChatGenerationErrorInfo >> retryInChat: chat [

	chat retryGenerating: generator
]
