Class {
	#name : 'AIChatGeneratedContent',
	#superclass : 'Object',
	#instVars : [
		'modelContentParts',
		'functionResponseParts'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGeneratedContent class >> modelContentParts: modelContentParts [

	^ self modelContentParts: modelContentParts functionResponseParts: OrderedCollection new
]

{ #category : 'Not categorized' }
AIChatGeneratedContent class >> modelContentParts: modelContentParts functionResponseParts: functionResponseParts [

	^ self basicNew initializeWithModelContentParts: modelContentParts functionResponseParts: functionResponseParts
]

{ #category : 'Not categorized' }
AIChatGeneratedContent class >> new [

	^ self modelContentParts: OrderedCollection new
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> addFunctionResponseParts: contentParts [

	functionResponseParts addAll: contentParts
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> functionCallParts [

	^ self modelContentParts select: [ :part | part isFunctionCall ]
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> functionResponseParts [

	^ functionResponseParts
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> initializeWithModelContentParts: initialModelContentParts functionResponseParts: initialFunctionResponseParts [

	self initialize.
	modelContentParts := initialModelContentParts.
	functionResponseParts := initialFunctionResponseParts.
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> modelContentJSON [

	^ EsOrderedDictionary with: 'role' -> 'model'
		with: 'parts' -> (self modelContentParts collect: [ :part | part json ])
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> modelContentParts [

	^ modelContentParts
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> userContentJSON [

	^ self functionResponseParts
		ifEmpty: [ nil ]
		ifNotEmpty: [ :parts |
			EsOrderedDictionary with: 'role' -> 'user'
				with: 'parts' -> (parts collect: [ :part | part json ]) ]
]
