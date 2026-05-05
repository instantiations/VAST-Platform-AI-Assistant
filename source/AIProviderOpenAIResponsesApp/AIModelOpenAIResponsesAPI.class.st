Class {
	#name : 'AIModelOpenAIResponsesAPI',
	#superclass : 'AIAbstractModel',
	#instVars : [
		'temperature',
		'top_p',
		'reasoningEffort',
		'reasoningSummary'
	],
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Initialization' }
AIModelOpenAIResponsesAPI >> copyStateFrom: anotherModel [
	super copyStateFrom: anotherModel.
	temperature := anotherModel temperature.
	top_p := anotherModel top_p.
	reasoningEffort := anotherModel reasoningEffort.
	reasoningSummary := anotherModel reasoningSummary
]

{ #category : 'Initialization' }
AIModelOpenAIResponsesAPI >> initialize [
	super initialize.
	reasoningEffort := 'medium'.
	reasoningSummary := 'detailed'
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> reasoningEffort [

	^ reasoningEffort
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> reasoningEffort: string [
	
	reasoningEffort := (self reasoningEffortChoices includes: string) ifTrue: [string]
]

{ #category : 'Options' }
AIModelOpenAIResponsesAPI >> reasoningEffortChoices [
"These are the options supported by Responses API - but not all options are supported by all models.
 Generation errors may occur if set incorrectly for a given model"
	^#('none' 'minimal' 'low' 'medium' 'high' 'xhigh')
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> reasoningSummary [

	^ reasoningSummary
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> reasoningSummary: string [

	reasoningSummary := (self reasoningSummaryChoices includes: string) ifTrue: [string]
]

{ #category : 'Options' }
AIModelOpenAIResponsesAPI >> reasoningSummaryChoices [
"These are the options supported by Responses API - but not all options are supported by all models.
 Generation errors may occur if set incorrectly for a given model"
	^#('auto' 'concise' 'detailed')
]

{ #category : 'Comparing' }
AIModelOpenAIResponsesAPI >> sameAs: anotherModel [

	^(super sameAs: anotherModel) and: [
		temperature = anotherModel temperature and: [
			top_p = anotherModel top_p and: [
				reasoningEffort = anotherModel reasoningEffort
					and: [reasoningSummary = anotherModel reasoningSummary]]]]
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> temperature [
	
	^temperature
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> temperature: aFloat [

	temperature  := aFloat
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> top_p [
	
	^top_p
]

{ #category : 'Accessing' }
AIModelOpenAIResponsesAPI >> top_p: aFloat [

	top_p := aFloat
]
