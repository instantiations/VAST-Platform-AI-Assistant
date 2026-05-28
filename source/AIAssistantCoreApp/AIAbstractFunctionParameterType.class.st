Class {
	#name : 'AIAbstractFunctionParameterType',
	#superclass : 'Object',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractFunctionParameterType class >> typeName [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameterType >> name [

	^ self class typeName
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameterType >> schemaJSON [

	^ EsOrderedDictionary with: 'type' -> self name
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameterType >> schemaJSONWithDescription: description [

	^ self schemaJSON
		at: 'description' put: description;
		yourself
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameterType >> validateArgument: argument [

	self subclassResponsibility
]
