Extension {
	#name : 'Class'
}

{ #category : 'Not categorized' }
Class >> geminiJSON [
	"Returns the JSON representation of the class definition."

	^ EsOrderedDictionary
		with: 'superclass' -> (self superclass ifNotNil: [ :sclass | sclass name ])
		with: 'instance_variables' -> self instVarNames
		with: 'class_variables' -> self classVarNames
		with: 'application' -> self controller name
]
