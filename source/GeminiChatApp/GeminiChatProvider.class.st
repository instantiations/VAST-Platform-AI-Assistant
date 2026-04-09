Class {
	#name : 'GeminiChatProvider',
	#superclass : 'GeminiChatAbstractProvider',
	#classInstVars : [
		'provider'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatProvider class >> provider [

	^ provider ifNil: [ provider := self new ]
]

{ #category : 'Not categorized' }
GeminiChatProvider class >> providers [

	^ { self provider }
]

{ #category : 'Not categorized' }
GeminiChatProvider class >> reset [

	provider := nil
]

{ #category : 'Not categorized' }
GeminiChatProvider >> apiKey [

	^ GeminiChat apiKey
]

{ #category : 'Not categorized' }
GeminiChatProvider >> apiKey: newAPIKey [

	^ GeminiChat apiKey: newAPIKey
]

{ #category : 'Not categorized' }
GeminiChatProvider >> label [

	^ 'Gemini'
]

{ #category : 'Not categorized' }
GeminiChatProvider >> models [

	^ GeminiChatGenerator models
]
