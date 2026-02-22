Class {
	#name : 'GeminiFunctionParameterTypeInteger',
	#superclass : 'GeminiAbstractFunctionParameterType',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeInteger >> name [

	^ 'integer'
]

{ #category : 'Not categorized' }
GeminiFunctionParameterTypeInteger >> validateArgument: argument [

	^ argument isInteger
]
