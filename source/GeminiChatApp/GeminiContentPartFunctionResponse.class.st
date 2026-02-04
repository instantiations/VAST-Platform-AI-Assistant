Class {
	#name : 'GeminiContentPartFunctionResponse',
	#superclass : 'GeminiAbstractContentPart',
	#instVars : [
		'id',
		'name',
		'response'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse class >> fromJSON: jsonObject [

	| typeJSONObject |

	self checkJSONObject: jsonObject hasNoOtherAttributesBesides: { self type }.
	typeJSONObject := jsonObject at: self type.
	^ self id: (typeJSONObject at: 'id' ifAbsent: [ nil ]) name: (typeJSONObject at: 'name') response: (typeJSONObject at: 'response')
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse class >> id: id name: functionName response: response [

	^ self basicNew initializeWithID: id name: functionName response: response; yourself
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse class >> type [

	^ 'functionResponse'
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse >> id [

	^ id
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse >> initializeWithID: initialID name: initialName response: initialResponse [

	self initialize.
	id := initialID.
	name := initialName.
	response := initialResponse.
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse >> json [

	^ EsOrderedDictionary with: self class type -> self jsonValue
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse >> jsonValue [

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
GeminiContentPartFunctionResponse >> name [

	^ name
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse >> response [

	^ response
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionResponse >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' id: '.
	id storeOn: stream.
	stream nextPutAll: ' name: '.
	name storeOn: stream.
	stream nextPutAll: ' response: '.
	response storeOn: stream.
	stream nextPut: $).
]
