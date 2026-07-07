Class {
	#name : 'AIFunctionParameterTypeInteger',
	#superclass : 'AIAbstractFunctionParameterType',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeInteger class >> fromJSONSchemaObject: jsonSchemaObject [

	self checkJSONSchemaObject: jsonSchemaObject hasNoOtherAttributesBesides: #('type' 'title' 'description').
	^ self new
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeInteger class >> typeName [

	^ 'integer'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeInteger >> validateArgument: argument [

	^ argument isInteger
]
