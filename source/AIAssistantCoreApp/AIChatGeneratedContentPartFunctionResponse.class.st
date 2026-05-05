Class {
	#name : 'AIChatGeneratedContentPartFunctionResponse',
	#superclass : 'AIAbstractChatGeneratedContentPart',
	#instVars : [
		'id',
		'name',
		'response'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse class >> id: id name: functionName response: response [

	^ self basicNew initializeWithID: id name: functionName response: response; yourself
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse >> id [

	^ id
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse >> initializeWithID: initialID name: initialName response: initialResponse [

	self initialize.
	id := initialID.
	name := initialName.
	response := initialResponse.
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse >> json [

	^ EsOrderedDictionary with: self class type -> self jsonValue
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse >> jsonValue [

	| jsonValue |

	jsonValue := EsOrderedDictionary new.
	id ifNotNil: [
		jsonValue at: 'id' put: id ].
	jsonValue
		at: 'name' put: name;
		at: 'response' put: response.
	^ jsonValue
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse >> name [

	^ name
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse >> response [

	^ response
]
