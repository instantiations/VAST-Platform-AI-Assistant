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
			self name: 'gemini-3-pro-preview' label: 'Pro 3' contextWindowSize: 2097152.
			self name: 'gemini-2.5-pro' label: 'Pro 2.5' contextWindowSize: 2097152.
			self name: 'gemini-2.5-flash' label: 'Flash 2.5' contextWindowSize: 1048576.
			self name: 'gemini-2.5-flash-lite' label: 'Flash-Lite 2.5' contextWindowSize: 1048576 } ].
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

{ #category : 'Not categorized' }
GeminiModel class >> named: modelName [

	^ self all detect: [ :model | model name = modelName ]
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
