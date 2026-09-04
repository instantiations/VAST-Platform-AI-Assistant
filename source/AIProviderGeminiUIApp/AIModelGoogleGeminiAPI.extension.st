Extension {
	#name : 'AIModelGoogleGeminiAPI'
}

{ #category : 'User Interface' }
AIModelGoogleGeminiAPI >> addSpecificDetailsTo: aPane in: aModel [

	aModel createGeminiModelDetailsOn: aPane
]

{ #category : 'User Interface' }
AIModelGoogleGeminiAPI >> hasParameters [

	^true
]
