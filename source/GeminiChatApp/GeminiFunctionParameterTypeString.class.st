Class {
	#name : 'GeminiFunctionParameterTypeString',
	#superclass : 'GeminiAbstractFunctionParameterType',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeString >> name [

	^ 'string'
]

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeString >> validateArgument: argument [

	^ argument isString
]
