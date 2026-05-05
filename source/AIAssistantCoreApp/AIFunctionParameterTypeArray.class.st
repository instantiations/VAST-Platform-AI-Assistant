Class {
	#name : 'AIFunctionParameterTypeArray',
	#superclass : 'AIAbstractFunctionParameterType',
	#instVars : [
		'itemsType'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray class >> itemsType: itemsType [

	^ self basicNew initializeWithItemsType: itemsType
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray >> initializeWithItemsType: initialItemsType [

	self initialize.
	itemsType := initialItemsType.
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeArray >> name [

	^ 'array'
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
