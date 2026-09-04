Extension {
	#name : 'SstHttpClient'
}

{ #category : 'Not categorized' }
SstHttpClient >> post: msgBody typed: mediaType at: aUrlObject ignoreContent: aBoolean [

	^ self post: msgBody typed: mediaType at: aUrlObject using: nil withHeaders: nil ignoreContent: aBoolean
]

{ #category : 'Not categorized' }
SstHttpClient >> post: msgBody typed: mediaType at: aUrlObject using: authCredentials withHeaders: headers ignoreContent: aBoolean [

	^ self
		createAndSendRequestFor: aUrlObject
		typed: mediaType
		using: authCredentials
		withHeaders: headers
		templateMessage: self templateHttpPOSTMessage copy
		data: msgBody
		assemblerPolicy: (self newAssemblerPolicy ignoreContent: aBoolean)
]

{ #category : 'Not categorized' }
SstHttpClient >> socketStream [

	^ localEndpoint transport connection stream
]
