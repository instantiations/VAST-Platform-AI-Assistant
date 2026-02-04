Class {
	#name : 'GeminiAbstractFunctionParameterType',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameterType >> name [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameterType >> schemaJSON [

	^ EsOrderedDictionary with: 'type' -> self name
]

{ #category : 'Not categorized' }
GeminiAbstractFunctionParameterType >> schemaJSONWithDescription: description [

	^ self schemaJSON
		at: 'description' put: description;
		yourself
]
