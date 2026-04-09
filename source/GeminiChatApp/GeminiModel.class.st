Class {
	#name : 'GeminiModel',
	#superclass : 'GeminiAbstractModel',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiModel class >> name: modelName label: label contextWindowSize: tokens [

	^ self basicNew initializeWithName: modelName label: label contextWindowSize: tokens
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiModel >> generatorClass [

	^ GeminiChatGenerator
]
