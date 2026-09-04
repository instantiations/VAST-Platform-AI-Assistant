Class {
	#name : 'AIModelGoogleGeminiAPI',
	#superclass : 'AIAbstractModel',
	#instVars : [
		'thinkingLevel'
	],
	#category : 'AIProviderGeminiApp'
}

{ #category : 'Initialization' }
AIModelGoogleGeminiAPI >> copyStateFrom: anotherModel [

	super copyStateFrom: anotherModel.
	thinkingLevel := anotherModel thinkingLevel
]

{ #category : 'Comparing' }
AIModelGoogleGeminiAPI >> sameAs: anotherModel [

	^(super sameAs: anotherModel) and: [
		thinkingLevel = anotherModel thinkingLevel]
]

{ #category : 'Accessing' }
AIModelGoogleGeminiAPI >> thinkingLevel [

	^thinkingLevel
]

{ #category : 'Accessing' }
AIModelGoogleGeminiAPI >> thinkingLevel: aString [

	thinkingLevel := (self thinkingLevelChoices includes: aString)
		ifTrue: [ aString ]
		ifFalse: [ nil ]
]

{ #category : 'Options' }
AIModelGoogleGeminiAPI >> thinkingLevelChoices [
"These are the thinking levels supported by Gemini models - but not all options are supported by all models.
 Generation errors may occur if set incorrectly for a given model"
	^#('minimal' 'low' 'medium' 'high')
]
