Extension {
	#name : 'EsOrderedDictionary'
}

{ #category : 'Converting' }
EsOrderedDictionary >> asFunctionCallArguments [

	^ AIFunctionCallArgumentsJSONObject jsonObject: self
]
