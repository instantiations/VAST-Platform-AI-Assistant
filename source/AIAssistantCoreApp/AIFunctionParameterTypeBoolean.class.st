Class {
	#name : 'AIFunctionParameterTypeBoolean',
	#superclass : 'AIAbstractFunctionParameterType',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeBoolean class >> fromJSONSchemaObject: jsonSchemaObject [

	self checkJSONSchemaObject: jsonSchemaObject hasNoOtherAttributesBesides: #('type' 'title' 'description').
	^ self new
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeBoolean class >> typeName [

	^ 'boolean'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeBoolean >> validateArgument: argument [

	^ argument isBoolean
]
