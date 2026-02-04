Class {
	#name : 'GeminiAbstractFunctionParameter',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type',
		'description'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameter class >> name: parameterName type: type description: parameterDescription [

	^ self basicNew initializeWithName: parameterName type: type description: parameterDescription
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameter >> description [

	^ description
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameter >> initializeWithName: initialName type: initialType description: initialDescription [

	self initialize.
	name := initialName.
	type := initialType.
	description := initialDescription.
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameter >> isRequired [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameter >> name [

	^ name
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameter >> type [

	^ type
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameter >> typeSchemaJSON [

	^ type schemaJSONWithDescription: description
]
