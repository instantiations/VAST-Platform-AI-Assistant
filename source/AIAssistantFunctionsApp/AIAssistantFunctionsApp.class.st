Class {
	#name : 'AIAssistantFunctionsApp',
	#superclass : 'Application',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIAssistantFunctionsApp class >> loaded [

	AIFunctionsSet resetCurrent
]

{ #category : 'Not categorized' }
AIAssistantFunctionsApp class >> removing [

	(AIFunctionsSet current allFunctions select: [ :function | function class controller = self ])
		do: [ :function | AIFunctionsSet current removeFunction: function ]
]
