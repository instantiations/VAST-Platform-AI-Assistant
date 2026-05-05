Class {
	#name : 'AIFunctionParameterTypeBoolean',
	#superclass : 'AIAbstractFunctionParameterType',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeBoolean >> name [

	^ 'boolean'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeBoolean >> validateArgument: argument [

	^ argument isBoolean
]
