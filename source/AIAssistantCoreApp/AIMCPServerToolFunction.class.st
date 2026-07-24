Class {
	#name : 'AIMCPServerToolFunction',
	#superclass : 'AIAbstractFunction',
	#instVars : [
		'server',
		'toolName'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIMCPServerToolFunction class >> isAbstract [

	^ true
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction class >> server: server toolName: toolName [

	^ self basicNew initializeWithServer: server toolName: toolName
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> applyFunctionTo: arguments in: context [

	^ self server call: 'tools/call' with: (EsOrderedDictionary with: 'name' -> self toolName with: 'arguments' -> arguments)
]

{ #category : 'Accessing' }
AIMCPServerToolFunction >> category [

	^ self server name
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> description [

	^ self tool at: 'description'
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> initializeWithServer: initialServer toolName: initialToolName [

	self initialize.
	server := initialServer.
	toolName := initialToolName.
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> name [

	^ '%1:%2' bindWith: self server functionNamePrefix with: self toolName
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> parameters [

	^ (self tool at: 'inputSchema') at: 'properties'
		ifPresent: [ :properties |
			| required |
			required := (self tool at: 'inputSchema') at: 'required' ifAbsent: [ #() ].
			properties associations collect: [ :association |
				((required includes: association key) ifTrue: [ AIFunctionParameterRequired ] ifFalse: [ AIFunctionParameterOptional ])
					name: association key
					type: ([ AIAbstractFunctionParameterType fromJSONSchemaObject: association value ]
						when: ExError do: [ :error |
							({ AIFunctionParameterTypeBoolean. AIFunctionParameterTypeInteger. AIFunctionParameterTypeNumber. AIFunctionParameterTypeString }
								detect: [ :typeClass | typeClass typeName = (association value at: 'type') ] ifNone: [ nil ])
								ifNotNil: [ :typeClass | error exitWith: typeClass new ]
								ifNil: [ error exitWith: (AIFunctionParameterTypeAny jsonSchema: association value) ] ])
					description: (association value at: 'description' ifAbsent: [ nil ]) ] ]
		ifAbsent: [ #() ]
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> server [

	^ server
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> tool [

	^ self server tools detect: [ :tool | (tool at: 'name') = self toolName ] ifNone: [ nil ]
]

{ #category : 'Not categorized' }
AIMCPServerToolFunction >> toolName [

	^ toolName
]
