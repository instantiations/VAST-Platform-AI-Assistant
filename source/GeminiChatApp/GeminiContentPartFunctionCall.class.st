Class {
	#name : 'GeminiContentPartFunctionCall',
	#superclass : 'GeminiAbstractContentPart',
	#instVars : [
		'id',
		'name',
		'arguments',
		'thoughtSignature'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall class >> fromJSON: jsonObject [

	| typeJSONObject |

	self checkJSONObject: jsonObject hasNoOtherAttributesBesides: { self type. 'thoughtSignature' }.
	typeJSONObject := jsonObject at: self type.
	^ self id: (typeJSONObject at: 'id' ifAbsent: [ nil ]) name: (typeJSONObject at: 'name')
		arguments: (typeJSONObject at: 'args' ifAbsent: [ nil ]) thoughtSignature: (jsonObject at: 'thoughtSignature' ifAbsent: [ nil ])
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall class >> id: id name: functionName arguments: arguments thoughtSignature: thoughtSignature [

	^ self basicNew initializeWithID: id name: functionName arguments: arguments thoughtSignature: thoughtSignature; yourself
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall class >> type [

	^ 'functionCall'
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> arguments [

	^ arguments
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> id [

	^ id
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> initializeWithID: initialID name: initialName arguments: initialArguments thoughtSignature: initialThoughtSignature [

	self initialize.
	id := initialID.
	name := initialName.
	arguments := initialArguments.
	thoughtSignature := initialThoughtSignature.
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> isFunctionCall [

	^ true
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> json [

	| jsonObject |

	jsonObject := EsOrderedDictionary with: self class type -> self jsonValue.
	self thoughtSignature ifNotNil: [ :value |
		jsonObject at: 'thoughtSignature' put: value ].
	^ jsonObject
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> jsonValue [

	| jsonValue |

	jsonValue := EsOrderedDictionary new.
	id ifNotNil: [
		jsonValue at: 'id' put: id ].
	jsonValue at: 'name' put: name.
	arguments ifNotNil: [
		jsonValue at: 'args' put: arguments ].
	^ jsonValue
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> name [

	^ name
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' id: '.
	id storeOn: stream.
	stream nextPutAll: ' name: '.
	name storeOn: stream.
	stream nextPutAll: ' arguments: '.
	arguments storeOn: stream.
	stream nextPutAll: ' thoughtSignature: '.
	thoughtSignature storeOn: stream.
	stream nextPut: $).
]

{ #category : 'Not categorized' }
GeminiContentPartFunctionCall >> thoughtSignature [

	^ thoughtSignature
]
