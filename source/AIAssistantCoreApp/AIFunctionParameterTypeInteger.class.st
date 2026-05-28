Class {
	#name : 'AIFunctionParameterTypeInteger',
	#superclass : 'AIAbstractFunctionParameterType',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeInteger class >> typeName [

	^ 'integer'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeInteger >> validateArgument: argument [

	^ argument isInteger
]
