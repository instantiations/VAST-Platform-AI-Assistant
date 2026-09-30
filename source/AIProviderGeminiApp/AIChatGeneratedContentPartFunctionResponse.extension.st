Extension {
	#name : 'AIChatGeneratedContentPartFunctionResponse'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse class >> fromJSON: jsonObject [

	| typeJSONObject |

	self checkJSONObject: jsonObject hasNoOtherAttributesBesides: { self type }.
	typeJSONObject := jsonObject at: self type.
	^ self id: (typeJSONObject at: 'id' ifAbsent: [ nil ]) name: (typeJSONObject at: 'name') response: (typeJSONObject at: 'response')
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionResponse class >> type [

	^ 'functionResponse'
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
