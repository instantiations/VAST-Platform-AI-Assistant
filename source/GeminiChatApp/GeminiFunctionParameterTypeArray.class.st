Class {
	#name : 'GeminiFunctionParameterTypeArray',
	#superclass : 'GeminiAbstractFunctionParameterType',
	#instVars : [
		'itemsType'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeArray class >> itemsType: itemsType [

	^ self basicNew initializeWithItemsType: itemsType
]

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeArray >> initializeWithItemsType: initialItemsType [

	self initialize.
	itemsType := initialItemsType.
]

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeArray >> name [

	^ 'array'
]

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeArray >> schemaJSON [

	^ super schemaJSON
		at: 'items' put: itemsType schemaJSON;
		yourself
]
