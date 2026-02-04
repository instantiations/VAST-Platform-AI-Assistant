Extension {
	#name : 'CompiledMethod'
}

{ #category : 'Not categorized' }
CompiledMethod >> geminiJSON [
	"Returns the JSON representation of the method."

	^ EsOrderedDictionary
		with: 'class' -> self methodClass asClass name
		with: 'side' -> (self methodClass isClass ifTrue: [ 'instance' ] ifFalse: [ 'class' ])
		with: 'categories' -> (self methodClass categoriesFor: self selector)
		with: 'selector' -> self selector
		with: 'source' -> self sourceString
]
