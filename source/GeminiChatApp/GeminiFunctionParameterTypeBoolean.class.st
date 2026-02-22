Class {
	#name : 'GeminiFunctionParameterTypeBoolean',
	#superclass : 'GeminiAbstractFunctionParameterType',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeBoolean >> name [

	^ 'boolean'
]

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeBoolean >> validateArgument: argument [

	^ argument isBoolean
]
