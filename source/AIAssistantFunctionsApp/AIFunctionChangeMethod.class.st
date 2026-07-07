Class {
	#name : 'AIFunctionChangeMethod',
	#superclass : 'AIFunctionAddMethod',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeMethod >> applicationParameterDefinition [

	^ AIFunctionParameterOptional name: 'application'
			type: AIFunctionParameterTypeString new
			description: 'The name of the application to place the method in. If not provided, the method remains in its current application'.
]

{ #category : 'Accessing' }
AIFunctionChangeMethod >> description [

	^ 'Changes an existing method in a class. Note: The generated method source code will be automatically displayed to the user. Do not output the code in your text response, but you can provide a textual explanation of the changes.'
]

{ #category : 'Accessing' }
AIFunctionChangeMethod >> name [

	^ 'change_method'
]
