Class {
	#name : 'AIModelProviderTestGoogleGeminiAPI',
	#superclass : 'AIModelProviderGoogleGeminiAPI',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Instance Creation' }
AIModelProviderTestGoogleGeminiAPI class >> createNamed: aLabel [

	^ self createNamed: aLabel baseUrl: ''
]

{ #category : 'Not categorized' }
AIModelProviderTestGoogleGeminiAPI class >> hasUniqueURL [

	^ false
]
