Class {
	#name : 'AIProviderOpenAIResponsesApp',
	#superclass : 'Application',
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Not categorized' }
AIProviderOpenAIResponsesApp class >> removing [

	AIAbstractModelProvider registeredProviders do: [ :provider |
		provider class = AIModelProviderOpenAIResponsesAPI ifTrue: [
			AIAbstractModelProvider unregisterProvider: provider ifUnregisteringModels: [ true ] ] ]
]
