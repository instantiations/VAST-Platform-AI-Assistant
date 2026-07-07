Class {
	#name : 'AIAssistantCoreApp',
	#superclass : 'Application',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAssistantCoreApp class >> loaded [

	AIFunctionsSet resetCurrent.
	AIChatGenerationLog resetCurrent.
]

{ #category : 'Not categorized' }
AIAssistantCoreApp class >> removing [

	AIAbstractModel reset.
	AIAbstractModelProvider reset.
	AIAbstractMCPServer reset.
	AIFunctionsSet clearCurrent.
	AIChatGenerationLog clearCurrent.
]
