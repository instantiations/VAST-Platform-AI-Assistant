Extension {
	#name : 'AIChatUserMessage'
}

{ #category : 'Not categorized' }
AIChatUserMessage >> addModelContentPartsToLastGeneratedContent: contentParts [

	generatedContents last addModelContentParts: contentParts
]

{ #category : 'Not categorized' }
AIChatUserMessage >> userContentJSON [

	^ EsOrderedDictionary with: 'role' -> 'user'
		with: 'parts' -> { EsOrderedDictionary with: 'text' -> message }
]
