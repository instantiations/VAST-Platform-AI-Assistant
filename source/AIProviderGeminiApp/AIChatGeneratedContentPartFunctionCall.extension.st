Extension {
	#name : 'AIChatGeneratedContentPartFunctionCall'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall class >> fromJSON: jsonObject [

	| typeJSONObject |

	self checkJSONObject: jsonObject hasNoOtherAttributesBesides: { self type. 'thoughtSignature' }.
	typeJSONObject := jsonObject at: self type.
	^ self id: (typeJSONObject at: 'id' ifAbsent: [ nil ]) name: (typeJSONObject at: 'name')
		arguments: (typeJSONObject at: 'args' ifAbsent: [ nil ]) thoughtSignature: (jsonObject at: 'thoughtSignature' ifAbsent: [ nil ])
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall class >> type [

	^ 'functionCall'
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> json [

	| jsonObject |

	jsonObject := EsOrderedDictionary with: self class type -> self jsonValue.
	self thoughtSignature ifNotNil: [ :value |
		jsonObject at: 'thoughtSignature' put: value ].
	^ jsonObject
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> jsonValue [

	| jsonValue |

	jsonValue := EsOrderedDictionary new.
	id ifNotNil: [
		jsonValue at: 'id' put: id ].
	jsonValue at: 'name' put: name.
	arguments ifNotNil: [
		jsonValue at: 'args' put: arguments jsonObject ].
	^ jsonValue
]
