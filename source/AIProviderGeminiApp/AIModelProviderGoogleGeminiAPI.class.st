"
A provider of the Gemini API; https://ai.google.dev/api/models

Usually, there will only be one: 
GeminiChatProvider addProvider: (GeminiChatProviderGemini createNamed: 'Gemini' host: 'generativelanguage.googleapis.com' secure: true).
"
Class {
	#name : 'AIModelProviderGoogleGeminiAPI',
	#superclass : 'AIAbstractModelProvider',
	#category : 'AIProviderGeminiApp'
}

{ #category : 'Accessing' }
AIModelProviderGoogleGeminiAPI class >> apiLabel [
	^'Gemini API'
]

{ #category : 'Testing' }
AIModelProviderGoogleGeminiAPI class >> hasUniqueURL [
	"The Gemini API is really only offered by Google"
	^true
]

{ #category : 'Instance Creation',
  #vaVisibility : 'private' }
AIModelProviderGoogleGeminiAPI class >> registerDefaultInstance [

	(AIAbstractModelProvider registeredProviders contains: [:one | one class = self])
		ifFalse: [
			AIAbstractModelProvider registerProvider: (self createNamed: 'Gemini' baseUrl: nil)]
]

{ #category : 'Instance Creation',
  #vaVisibility : 'private' }
AIModelProviderGoogleGeminiAPI class >> uniqueURL [
	"The Gemini API is really only offered by Google"
	^'https://generativelanguage.googleapis.com'
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIModelProviderGoogleGeminiAPI >> generatorClass [

	^AIChatGeneratorGoogleGeminiAPI
]

{ #category : 'Models',
  #vaVisibility : 'private' }
AIModelProviderGoogleGeminiAPI >> parseModels: jsonObject [

	^((jsonObject at: 'models') select: [:each |
		((each at: 'supportedGenerationMethods') includes: 'generateContent')
			and: [(each at: 'inputTokenLimit') > 200000 and: [(each includesKey: 'thinking')]]])
				collect: [:modelJSONObject |
					AIModelGoogleGeminiAPI
						name: ((modelJSONObject at: 'name') copyFrom: 'models/' size + 1 to: (modelJSONObject at: 'name') size)
						label: (modelJSONObject at: 'displayName')
						provider: self
						contextWindowSize: (modelJSONObject at: 'inputTokenLimit')]
]

{ #category : 'Endpoints' }
AIModelProviderGoogleGeminiAPI >> requestCredentials [
	"Using the Gemini API, basic auth is not utilized"
	^nil
]

{ #category : 'Endpoints' }
AIModelProviderGoogleGeminiAPI >> requestHeaders [
	"Using the Gemini API, the api key is passed in a custom header field:
	 https://ai.google.dev/api#authentication
	 "
	^EsOrderedDictionary with: 'x-goog-api-key' -> apiKey
]

{ #category : 'Endpoints' }
AIModelProviderGoogleGeminiAPI >> urlAPIFor: model [

	^ self baseUrl path: ('/v1beta/models/%1:streamGenerateContent' bindWith: model name)
]

{ #category : 'Endpoints',
  #vaVisibility : 'private' }
AIModelProviderGoogleGeminiAPI >> urlModels [

	^self baseUrl path: '/v1beta/models'
]
