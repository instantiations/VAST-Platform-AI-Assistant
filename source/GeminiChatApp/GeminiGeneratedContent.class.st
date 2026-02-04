Class {
	#name : 'GeminiGeneratedContent',
	#superclass : 'Object',
	#instVars : [
		'modelContentParts',
		'functionResponseParts'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiGeneratedContent class >> modelContentParts: modelContentParts [

	^ self modelContentParts: modelContentParts functionResponseParts: OrderedCollection new
]

{ #category : 'Not categorized' }
GeminiGeneratedContent class >> modelContentParts: modelContentParts functionResponseParts: functionResponseParts [

	^ self basicNew initializeWithModelContentParts: modelContentParts functionResponseParts: functionResponseParts
]

{ #category : 'Not categorized' }
GeminiGeneratedContent class >> new [

	^ self modelContentParts: OrderedCollection new
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> addFunctionResponseParts: contentParts [

	functionResponseParts addAll: contentParts
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> addModelContentParts: contentParts [

	modelContentParts addAll: contentParts
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> functionCallParts [

	^ self modelContentParts select: [ :part | part isFunctionCall ]
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> functionResponseParts [

	^ functionResponseParts
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> initializeWithModelContentParts: initialModelContentParts functionResponseParts: initialFunctionResponseParts [

	self initialize.
	modelContentParts := initialModelContentParts.
	functionResponseParts := initialFunctionResponseParts.
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> modelContentJSON [

	^ EsOrderedDictionary with: 'role' -> 'model'
		with: 'parts' -> (self modelContentParts collect: [ :part | part json ])
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> modelContentParts [

	^ modelContentParts
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' modelContentParts: '.
	modelContentParts storeOn: stream.
	stream nextPutAll: ' functionResponseParts: '.
	functionResponseParts storeOn: stream.
	stream nextPut: $).
]

{ #category : 'Not categorized' }
GeminiGeneratedContent >> userContentJSON [

	^ self functionResponseParts
		ifEmpty: [ nil ]
		ifNotEmpty: [ :parts |
			EsOrderedDictionary with: 'role' -> 'user'
				with: 'parts' -> (parts collect: [ :part | part json ]) ]
]
