Class {
	#name : 'AIModelProviderOpenAIResponsesAPI',
	#superclass : 'AIAbstractModelProvider',
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Accessing' }
AIModelProviderOpenAIResponsesAPI class >> apiLabel [
	^'Responses API (OpenAI)'
]

{ #category : 'Accessing' }
AIModelProviderOpenAIResponsesAPI >> generatorClass [

	^ AIChatGeneratorOpenAIResponsesAPI
]

{ #category : 'Models',
  #vaVisibility : 'private' }
AIModelProviderOpenAIResponsesAPI >> parseModels: aJSONObject [
	^ (aJSONObject at: 'data') collect: [ :modelJSONObject |
		AIModelOpenAIResponsesAPI name: (modelJSONObject at: 'id') label: (modelJSONObject at: 'id') provider: self]
]

{ #category : 'Endpoints' }
AIModelProviderOpenAIResponsesAPI >> requestCredentials [
	"API key is passed as basic auth"
	^apiKey isNil ifFalse: [ 'Bearer ' , apiKey ].
]

{ #category : 'Endpoints' }
AIModelProviderOpenAIResponsesAPI >> requestHeaders [
	"OpenAI does not require any custom request headers"
	^nil
]

{ #category : 'Endpoints' }
AIModelProviderOpenAIResponsesAPI >> urlAPIFor: aModel [

	^self baseUrl path: '/v1/responses'
]

{ #category : 'Endpoints',
  #vaVisibility : 'private' }
AIModelProviderOpenAIResponsesAPI >> urlModels [

	^self baseUrl path: '/v1/models'
]
