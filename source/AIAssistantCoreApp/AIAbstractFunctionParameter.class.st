Class {
	#name : 'AIAbstractFunctionParameter',
	#superclass : 'Object',
	#instVars : [
		'name',
		'type',
		'description'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractFunctionParameter class >> name: parameterName type: type description: parameterDescription [

	^ self basicNew initializeWithName: parameterName type: type description: parameterDescription
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameter >> description [

	^ description
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameter >> initializeWithName: initialName type: initialType description: initialDescription [

	self initialize.
	name := initialName.
	type := initialType.
	description := initialDescription.
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameter >> isRequired [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameter >> name [

	^ name
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameter >> type [

	^ type
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameter >> typeSchemaJSON [

	^ type schemaJSONWithDescription: description
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameter >> validateArgument: argument [

	^ type validateArgument: argument
]
