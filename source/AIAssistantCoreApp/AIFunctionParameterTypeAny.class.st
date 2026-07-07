Class {
	#name : 'AIFunctionParameterTypeAny',
	#superclass : 'AIAbstractFunctionParameterType',
	#instVars : [
		'jsonSchema'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeAny class >> fromJSONSchemaObject: jsonSchema [

	^ self jsonSchema: jsonSchema
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeAny class >> jsonSchema: jsonSchema [

	^ self basicNew initializeWithJSONSchema: jsonSchema
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeAny class >> typeName [

	^ nil
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeAny >> initializeWithJSONSchema: initialJSONSchema [

	self initialize.
	jsonSchema := initialJSONSchema.
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeAny >> schemaJSON [

	^ EsOrderedDictionary new
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeAny >> schemaJSONWithDescription: description [

	^ super schemaJSONWithDescription: (String streamContents: [ :stream |
		(description notNil and: [ description notEmpty ]) ifTrue: [
			stream nextPutAll: description; nextPut: Character lf; nextPut: Character lf ].
		stream nextPutAll: 'The declared schema is incomplete, the full schema is: ' , (AIJSONWriter toString: jsonSchema) ])
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeAny >> validateArgument: argument [

	^ true
]
