Extension {
	#name : 'AIModelOpenAIResponsesAPI'
}

{ #category : 'User Interface' }
AIModelOpenAIResponsesAPI >> addSpecificDetailsTo: aPane in: aModel [

	aModel createResponsesModelDetailsOn: aPane
]

{ #category : 'User Interface' }
AIModelOpenAIResponsesAPI >> hasParameters [
	^true
]
