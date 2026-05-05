Class {
	#name : 'AIFunctionParameterTypeInteger',
	#superclass : 'AIAbstractFunctionParameterType',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeInteger >> name [

	^ 'integer'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeInteger >> validateArgument: argument [

	^ argument isInteger
]
