Class {
	#name : 'GeminiModel',
	#superclass : 'Object',
	#instVars : [
		'name',
		'label',
		'contextWindowSize'
	],
	#classInstVars : [
		'allModels',
		'defaultModel'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Accessing' }
GeminiModel class >> all [

	allModels ifNil: [
		allModels := {
			self name: 'gemini-3.1-pro-preview' label: '3.1 Pro Preview' contextWindowSize: 1048576.
			self name: 'gemini-3.1-flash-lite-preview' label: '3.1 Flash-Lite Preview' contextWindowSize: 1048576.
			self name: 'gemini-3-flash-preview' label: '3 Flash Preview' contextWindowSize: 1048576.
			self name: 'gemini-2.5-pro' label: '2.5 Pro' contextWindowSize: 1048576.
			self name: 'gemini-2.5-flash' label: '2.5 Flash' contextWindowSize: 1048576.
			self name: 'gemini-2.5-flash-lite' label: '2.5 Flash-Lite' contextWindowSize: 1048576 } ].
	^ allModels
]

{ #category : 'Accessing' }
GeminiModel class >> default [

	defaultModel ifNil: [ defaultModel := self all first ].
	^ defaultModel
]

{ #category : 'Accessing' }
GeminiModel class >> default: model [

	defaultModel := model
]

{ #category : 'Instance Creation' }
GeminiModel class >> name: modelName label: label contextWindowSize: tokens [

	^ self basicNew initializeWithName: modelName label: label contextWindowSize: tokens
]

{ #category : 'Accessing' }
GeminiModel class >> named: modelName [

	^ self all detect: [ :model | model name = modelName ]
]

{ #category : 'Accessing' }
GeminiModel class >> reset [

	allModels := nil.
	defaultModel := nil.
]

{ #category : 'Comparing' }
GeminiModel >> = otherObject [

	^ self class = otherObject class
		and: [ self name = otherObject name
		and: [ self label = otherObject label ] ]
]

{ #category : 'Accessing' }
GeminiModel >> contextWindowSize [
	^contextWindowSize
]

{ #category : 'Comparing' }
GeminiModel >> hash [

	^ self name hash xor: self label hash
]

{ #category : 'Initialization' }
GeminiModel >> initializeWithName: initialName label: initialLabel contextWindowSize: tokens [

	self initialize.
	name := initialName.
	label := initialLabel.
	contextWindowSize := tokens
]

{ #category : 'Accessing' }
GeminiModel >> label [

	^ label
]

{ #category : 'Accessing' }
GeminiModel >> name [

	^ name
]

{ #category : 'Accessing' }
GeminiModel >> url [

	^ (SstUrl fromString: ('https://generativelanguage.googleapis.com/v1beta/models/%1:streamGenerateContent' bindWith: self name))
		encodeQuery: (Dictionary with: 'key' -> GeminiChat apiKey);
		yourself
]
