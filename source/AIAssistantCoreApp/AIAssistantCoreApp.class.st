Class {
	#name : 'AIAssistantCoreApp',
	#superclass : 'Application',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAssistantCoreApp class >> loaded [

	AIChatGenerationLog resetCurrent
]

{ #category : 'Not categorized' }
AIAssistantCoreApp class >> removing [

	AIAbstractModel reset.
	AIAbstractModelProvider reset.
	AIChatGenerationLog clearCurrent.
]
