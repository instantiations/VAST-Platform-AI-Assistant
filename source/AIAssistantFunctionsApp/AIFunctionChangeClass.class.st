Class {
	#name : 'AIFunctionChangeClass',
	#superclass : 'AIFunctionAddClass',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeClass >> applicationParameterDefinition [

	^	AIFunctionParameterOptional name: 'application'
			type: AIFunctionParameterTypeString new
			description: 'The name of the application that the class must move to. Defaults to the current application of the class.'.
]

{ #category : 'Actions' }
AIFunctionChangeClass >> applyFunctionTo: arguments in: context [
	| className |
	className := arguments at: 'class_name'.
	(self classNamed: className) ifNil:[ ^EsOrderedDictionary with: 'error' -> ('Class %1 not found' bindWith: className) ].
	^ super applyFunctionTo: arguments in: context.
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionChangeClass >> defaultApplicationNameForClassName: className [

	^ (self classNamed: className) controller name asString
]

{ #category : 'Accessing' }
AIFunctionChangeClass >> description [

	^ 'Changes an existing class by modifying its definition (e.g., changing its instance variables). Note: The generated class definition will be automatically displayed to the user in a code block. Do not output the code in your text response, but you can provide a textual explanation of the changes.'
]

{ #category : 'Accessing' }
AIFunctionChangeClass >> name [

	^ 'change_class'
]
