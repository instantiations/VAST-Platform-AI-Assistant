Class {
	#name : 'GeminiChatGenerationErrorInfo',
	#superclass : 'Object',
	#instVars : [
		'error',
		'generator'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatGenerationErrorInfo class >> forError: anError withGenerator: aGeminiGenerator [

	^ self new initializeForError: anError withGenerator: aGeminiGenerator
]

{ #category : 'Not categorized' }
GeminiChatGenerationErrorInfo >> description [

	^ error description


]

{ #category : 'Not categorized' }
GeminiChatGenerationErrorInfo >> error  [

	^ error
]

{ #category : 'Not categorized' }
GeminiChatGenerationErrorInfo >> initializeForError: anError withGenerator: aGeminiGenerator [

	error := anError.
	generator := aGeminiGenerator
]

{ #category : 'Not categorized' }
GeminiChatGenerationErrorInfo >> retryInChat: aGeminiChat [

	aGeminiChat retryGenerating: generator
]
