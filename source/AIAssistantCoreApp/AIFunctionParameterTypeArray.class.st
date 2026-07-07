Class {
	#name : 'AIFunctionParameterTypeArray',
	#superclass : 'AIAbstractFunctionParameterType',
	#instVars : [
		'itemsType'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray class >> fromJSONSchemaObject: jsonSchemaObject [

	self checkJSONSchemaObject: jsonSchemaObject hasNoOtherAttributesBesides: #('type' 'title' 'description' 'items').
	^ AIFunctionParameterTypeArray itemsType: (AIAbstractFunctionParameterType fromJSONSchemaObject: (jsonSchemaObject at: 'items'))
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray class >> itemsType: itemsType [

	^ self basicNew initializeWithItemsType: itemsType
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray class >> typeName [

	^ 'array'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray >> initializeWithItemsType: initialItemsType [

	self initialize.
	itemsType := initialItemsType.
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray >> schemaJSON [

	^ super schemaJSON
		at: 'items' put: itemsType schemaJSON;
		yourself
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray >> validateArgument: argument [

	^ argument isArray and: [ argument allSatisfy: [ :argumentItem | itemsType validateArgument: argumentItem ] ]
]
