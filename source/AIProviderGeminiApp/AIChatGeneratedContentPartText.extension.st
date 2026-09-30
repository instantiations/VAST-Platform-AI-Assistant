Extension {
	#name : 'AIChatGeneratedContentPartText'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText class >> fromJSON: jsonObject [

	self checkJSONObject: jsonObject hasNoOtherAttributesBesides: { self type. 'thought'. 'thoughtSignature' }.
	^ self string: (jsonObject at: self type) thought: (jsonObject at: 'thought' ifAbsent: [ nil ])
		thoughtSignature: (jsonObject at: 'thoughtSignature' ifAbsent: [ nil ])
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText class >> type [

	^ 'text'
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> json [

	| jsonObject |

	jsonObject := EsOrderedDictionary with: self class type -> self jsonValue.
	self isThought ifNotNil: [ :value |
		jsonObject at: 'thought' put: value ].
	self thoughtSignature ifNotNil: [ :value |
		jsonObject at: 'thoughtSignature' put: value ].
	^ jsonObject
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> jsonValue [

	^ string
]
