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
