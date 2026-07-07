Class {
	#name : 'AIFunctionParameterTypeNumber',
	#superclass : 'AIAbstractFunctionParameterType',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeNumber class >> fromJSONSchemaObject: jsonSchemaObject [

	self checkJSONSchemaObject: jsonSchemaObject hasNoOtherAttributesBesides: #('type' 'title' 'description').
	^ self new
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeNumber class >> typeName [

	^ 'number'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeNumber >> validateArgument: argument [

	^ argument isInteger | argument isFloat
]
