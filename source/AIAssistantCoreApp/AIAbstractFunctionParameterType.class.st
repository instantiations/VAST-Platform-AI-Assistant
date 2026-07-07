Class {
	#name : 'AIAbstractFunctionParameterType',
	#superclass : 'Object',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractFunctionParameterType class >> checkJSONSchemaObject: jsonObject hasNoOtherAttributesBesides: expectedAttributes [

	^ (jsonObject keys difference: expectedAttributes) ifNotEmpty: [ :otherAttributes |
		Error signal: ('Cannot instantiate %1 from JSON object with attributes: %2' bindWith: self class name with: (otherAttributes sorted joinUsing: ', ')) ]
]

{ #category : 'Not categorized' }
AIAbstractFunctionParameterType class >> fromJSONSchemaObject: jsonSchemaObject [

	| type |

	type := jsonSchemaObject at: 'type' ifAbsent: [ nil ].
	^ (self subclasses detect: [ :subclass | subclass typeName = type ] ifNone: [ Error signal: 'Unrecognized type of JSON schema object' ])
		fromJSONSchemaObject: jsonSchemaObject
]

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
