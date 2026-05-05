Extension {
	#name : 'AIChatUserMessage'
}

{ #category : 'Not categorized' }
AIChatUserMessage >> mergeModelContentPartIntoLastGeneratedContent: contentPart [

	generatedContents last mergeModelContentPart: contentPart
]
