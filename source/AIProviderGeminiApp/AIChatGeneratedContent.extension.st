Extension {
	#name : 'AIChatGeneratedContent'
}

{ #category : 'Not categorized' }
AIChatGeneratedContent >> addModelContentParts: contentParts [

	modelContentParts addAll: contentParts
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> modelContentJSON [

	^ EsOrderedDictionary with: 'role' -> 'model'
		with: 'parts' -> (self modelContentParts collect: [ :part | part json ])
]

{ #category : 'Not categorized' }
AIChatGeneratedContent >> userContentJSON [

	^ self functionResponseParts
		ifEmpty: [ nil ]
		ifNotEmpty: [ :parts |
			EsOrderedDictionary with: 'role' -> 'user'
				with: 'parts' -> (parts collect: [ :part | part json ]) ]
]
