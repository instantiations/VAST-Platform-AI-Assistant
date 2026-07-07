Extension {
	#name : 'Class'
}

{ #category : 'AIAssistant' }
Class >> aiJSON [
	"Returns the JSON representation of the class definition."

	^ EsOrderedDictionary
		with: 'superclass' -> (self superclass ifNotNil: [ :sclass | sclass name asString ])
		with: 'instance_variables' -> self instVarNames
		with: 'class_variables' -> self classVarNames
		with: 'pool_dictionaries' -> (self sharedPoolNames collect: [:p | p asString ])
		with: 'application' -> self controller name asString
]
