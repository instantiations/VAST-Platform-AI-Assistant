Extension {
	#name : 'AIAbstractModel'
}

{ #category : 'User Interface' }
AIAbstractModel >> addSpecificDetailsTo: modelDetailsPane in: modelSettings [
	"Different models will have different details to set"
	^self subclassResponsibility
]

{ #category : 'User Interface' }
AIAbstractModel >> hasParameters [
	"Override this to return true, and implement addSpecificDetailsTo:in: if the model contains configurable parameters"
	^false
]
