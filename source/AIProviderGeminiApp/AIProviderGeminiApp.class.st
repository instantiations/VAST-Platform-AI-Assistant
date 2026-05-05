Class {
	#name : 'AIProviderGeminiApp',
	#superclass : 'Application',
	#category : 'AIProviderGeminiApp'
}

{ #category : 'Not categorized' }
AIProviderGeminiApp class >> loaded [

	AIModelProviderGoogleGeminiAPI registerDefaultInstance
]

{ #category : 'Not categorized' }
AIProviderGeminiApp class >> removing [

	AIAbstractModelProvider registeredProviders do: [ :provider |
		provider class = AIModelProviderGoogleGeminiAPI ifTrue: [
			AIAbstractModelProvider unregisterProvider: provider ifUnregisteringModels: [ true ] ] ]
]
