Extension {
	#name : 'CompiledMethod'
}

{ #category : 'Not categorized' }
CompiledMethod >> aiJSON [
	"Returns the JSON representation of the method."

	^ self aiJSONWithoutSource
		add: 'source' -> self sourceString;
		yourself
]

{ #category : 'Not categorized' }
CompiledMethod >> aiJSONWithoutSource [
	"Returns the JSON representation of the method."

	^ EsOrderedDictionary
		with: 'class' -> self methodClass asClass name asString
		with: 'side' -> (self methodClass isClass ifTrue: [ 'instance' ] ifFalse: [ 'class' ])
		with: 'is_private' -> self isPrivate
		with: 'categories' -> (self methodClass categoriesFor: self selector)
		with: 'selector' -> self selector asString
]
