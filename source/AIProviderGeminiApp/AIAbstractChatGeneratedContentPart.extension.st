Extension {
	#name : 'AIAbstractChatGeneratedContentPart'
}

{ #category : 'Not categorized' }
AIAbstractChatGeneratedContentPart class >> checkJSONObject: jsonObject hasNoOtherAttributesBesides: expectedAttributes [

	^ (jsonObject keys difference: expectedAttributes) ifNotEmpty: [ :otherAttributes |
		Error signal: ('Cannot instantiate %1 from JSON object with attributes: %2' bindWith: self class name with: (otherAttributes joinUsing: ', ')) ]
]

{ #category : 'Not categorized' }
AIAbstractChatGeneratedContentPart class >> fromJSON: jsonObject [

	self subclasses do: [ :subclass |
		jsonObject at: subclass type ifPresent: [ :jsonValue |
			^ subclass fromJSON: jsonObject ] ].
	Error signal: 'Unrecognized type of content part'
]
