Extension {
	#name : 'SstHttpClient'
}

{ #category : 'Not categorized' }
SstHttpClient >> post: msgBody typed: mediaType at: aUrlObject streaming: aBoolean [

	^ self post: msgBody typed: mediaType at: aUrlObject using: nil withHeaders: nil streaming: aBoolean
]

{ #category : 'Not categorized' }
SstHttpClient >> post: msgBody typed: mediaType at: aUrlObject using: authCredentials withHeaders: headers streaming: aBoolean [

	^ self
		createAndSendRequestFor: aUrlObject
		typed: mediaType
		using: authCredentials
		withHeaders: headers
		templateMessage: self templateHttpPOSTMessage copy
		data: msgBody
		assemblerPolicy: (self newAssemblerPolicy streamContents: aBoolean)
]
