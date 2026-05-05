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
