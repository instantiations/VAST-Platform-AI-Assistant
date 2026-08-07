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

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeMethod >> applyExistingDefaultsFor: existingMethod withCategories: categories isPrivate: isPrivate to: change [
	
	categories ifNil: [
		existingMethod ifNotNil: [change protocols: (existingMethod methodClass categoriesFor: change selector)]].

	isPrivate ifNil: [
		existingMethod ifNotNil: [change isPrivate: existingMethod isPrivate]]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeMethod >> categoriesParameterDescription [

	^ 'The categories to classify the method under. Defaults to existing categories'
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeMethod >> checkExistingMethod: existingMethod ifError: errorBlock [

	existingMethod ifNil: [ errorBlock value: (EsOrderedDictionary with: 'error' -> 'Method does not exist. Use add_method instead.') ]
]

{ #category : 'Accessing' }
AIFunctionChangeMethod >> description [

	^ 'Changes an existing method in a class. Note: The generated method source code will be automatically displayed to the user. Do not output the code in your text response, but you can provide a textual explanation of the changes.'
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeMethod >> isPrivateParameterDescription [

	^ 'True if the method should be private, false otherwise. Defaults to visibility of existing method.'.
]

{ #category : 'Accessing' }
AIFunctionChangeMethod >> name [

	^ 'change_method'
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeMethod >> retrieveIsPrivateIn: arguments [

	^ arguments at: 'is_private' ifAbsent: [ nil ]
]
