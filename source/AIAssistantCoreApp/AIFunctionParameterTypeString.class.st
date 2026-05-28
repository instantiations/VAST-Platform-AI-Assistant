Class {
	#name : 'AIFunctionParameterTypeString',
	#superclass : 'AIAbstractFunctionParameterType',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIFunctionParameterTypeString class >> typeName [

	^ 'string'
]

{ #category : 'Not categorized' }
AIFunctionParameterTypeString >> validateArgument: argument [

	^ argument isString
]
