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
