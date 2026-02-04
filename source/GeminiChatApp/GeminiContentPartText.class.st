Class {
	#name : 'GeminiContentPartText',
	#superclass : 'GeminiAbstractContentPart',
	#instVars : [
		'string',
		'thought',
		'thoughtSignature'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiContentPartText class >> fromJSON: jsonObject [

	self checkJSONObject: jsonObject hasNoOtherAttributesBesides: { self type. 'thought'. 'thoughtSignature' }.
	^ self string: (jsonObject at: self type) thought: (jsonObject at: 'thought' ifAbsent: [ nil ])
		thoughtSignature: (jsonObject at: 'thoughtSignature' ifAbsent: [ nil ])
]

{ #category : 'Not categorized' }
GeminiContentPartText class >> string: string [

	^ self string: string thought: nil thoughtSignature: nil
]

{ #category : 'Not categorized' }
GeminiContentPartText class >> string: string thought: isThought thoughtSignature: thoughtSignature [

	^ self basicNew initializeWithString: string thought: isThought thoughtSignature: thoughtSignature; yourself
]

{ #category : 'Not categorized' }
GeminiContentPartText class >> type [

	^ 'text'
]

{ #category : 'Not categorized' }
GeminiContentPartText >> initializeWithString: initialString thought: initialThought thoughtSignature: initialThoughtSignature [

	self initialize.
	string := initialString.
	thought := initialThought.
	thoughtSignature := initialThoughtSignature.
]

{ #category : 'Not categorized' }
GeminiContentPartText >> isText [

	^ true
]

{ #category : 'Not categorized' }
GeminiContentPartText >> isThought [

	^ thought ifNil: [ false ] ifNotNil: [ thought ]
]

{ #category : 'Not categorized' }
GeminiContentPartText >> json [

	| jsonObject |

	jsonObject := EsOrderedDictionary with: self class type -> self jsonValue.
	self isThought ifNotNil: [ :value |
		jsonObject at: 'thought' put: value ].
	self thoughtSignature ifNotNil: [ :value |
		jsonObject at: 'thoughtSignature' put: value ].
	^ jsonObject
]

{ #category : 'Not categorized' }
GeminiContentPartText >> jsonValue [

	^ string
]

{ #category : 'Not categorized' }
GeminiContentPartText >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' string: '.
	string storeOn: stream.
	stream nextPutAll: ' thought: '.
	thought storeOn: stream.
	stream nextPutAll: ' thoughtSignature: '.
	thoughtSignature storeOn: stream.
	stream nextPut: $).
]

{ #category : 'Not categorized' }
GeminiContentPartText >> string [

	^ string
]

{ #category : 'Not categorized' }
GeminiContentPartText >> thought [

	^ thought
]

{ #category : 'Not categorized' }
GeminiContentPartText >> thoughtSignature [

	^ thoughtSignature
]
