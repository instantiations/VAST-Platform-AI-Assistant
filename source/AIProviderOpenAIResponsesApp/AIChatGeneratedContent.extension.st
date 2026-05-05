Extension {
	#name : 'AIChatGeneratedContent'
}

{ #category : 'Not categorized' }
AIChatGeneratedContent >> mergeModelContentPart: contentPart [

	(contentPart isText and: [ modelContentParts notEmpty and: [ modelContentParts last isText and: [
		contentPart isThought = modelContentParts last isThought and: [ contentPart thoughtSignature = modelContentParts last thoughtSignature ] ] ] ]) ifFalse: [
			modelContentParts add: contentPart.
			^ self ].
	modelContentParts add: (AIChatGeneratedContentPartText string: modelContentParts removeLast string , contentPart string thought: contentPart thought thoughtSignature: contentPart thoughtSignature)
]
