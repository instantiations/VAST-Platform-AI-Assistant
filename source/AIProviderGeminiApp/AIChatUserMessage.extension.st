Extension {
	#name : 'AIChatUserMessage'
}

{ #category : 'Not categorized' }
AIChatUserMessage >> addModelContentPartsToLastGeneratedContent: contentParts [

	generatedContents last addModelContentParts: contentParts
]
