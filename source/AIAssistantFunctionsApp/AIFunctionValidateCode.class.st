Class {
	#name : 'AIFunctionValidateCode',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionValidateCode >> applyFunctionTo: arguments in: context [
	| isClassSide |
	
	isClassSide := self isClassSideParametervalue: (arguments at: 'side' ifAbsent: [ 'instance' ]).
	isClassSide ifNil:[ ^EsOrderedDictionary with: 'error' -> ('Invalid value for parameter ''side'': %1' bindWith: (arguments at: 'side')) ].
	
	^  self validate: (arguments at: 'code') forEvaluation: true context: context targetClassName: (arguments at: 'class' ifAbsent: [nil]) isClassSide: isClassSide
]

{ #category : 'Accessing' }
AIFunctionValidateCode >> category [

	^ 'Testing & Debugging'
]

{ #category : 'Accessing' }
AIFunctionValidateCode >> description [

	^ 'Validates syntax and checks for sent selectors with no known implementors of a Smalltalk expression/script. Do not use this to validate full method definitions. The method modification tools (add_method, change_method) automatically perform their own validation.'
]

{ #category : 'Accessing' }
AIFunctionValidateCode >> name [

	^ 'validate_code'
]

{ #category : 'Accessing' }
AIFunctionValidateCode >> parameters [

	^ {
		AIFunctionParameterRequired name: 'code'
			type: AIFunctionParameterTypeString new
			description: 'The VAST Smalltalk code'.
		AIFunctionParameterOptional name: 'class'
			type: AIFunctionParameterTypeString new
			description: 'The name of the class the code is intended for, used to resolve instance and class variables.'.
		AIFunctionParameterOptional name: 'side'
			type: AIFunctionParameterTypeString new
			description: '''instance'' for an instance method/expression, ''class'' for a class method/expression. Defaults to ''instance''.' }
]
