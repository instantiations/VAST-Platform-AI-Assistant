Extension {
	#name : 'CompiledMethod'
}

{ #category : 'AIAssistant' }
CompiledMethod >> aiJSON [
	"Returns the JSON representation of the method."

	^ self aiJSONWithoutSource
		add: 'source' -> self sourceString;
		yourself
]

{ #category : 'AIAssistant' }
CompiledMethod >> aiJSONWithoutSource [
	"Returns the JSON representation of the method."

	^ EsOrderedDictionary
		with: 'class' -> self methodClass asClass name asString
		with: 'side' -> (self methodClass isClass ifTrue: [ 'instance' ] ifFalse: [ 'class' ])
		with: 'application' -> self application name asString
		with: 'is_private' -> self isPrivate
		with: 'categories' -> (self methodClass categoriesFor: self selector)
		with: 'selector' -> self selector asString
]
