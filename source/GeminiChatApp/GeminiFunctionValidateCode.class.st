Class {
	#name : 'GeminiFunctionValidateCode',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionValidateCode >> applyFunctionTo: arguments in: context [

	^ self validate: (arguments at: 'code') ifValid: [ EsOrderedDictionary with: 'valid' -> true ]
]

{ #category : 'Not categorized' }
GeminiFunctionValidateCode >> description [

	^ 'Validates syntax and checks for sent selectors with no known implementors.'
]

{ #category : 'Not categorized' }
GeminiFunctionValidateCode >> name [

	^ 'validate_code'
]

{ #category : 'Not categorized' }
GeminiFunctionValidateCode >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'code'
			type: GeminiFunctionParameterTypeString new
			description: 'The VAST Smalltalk code' }
]

{ #category : 'Not categorized' }
GeminiFunctionValidateCode >> validate: code ifSyntaxError: syntaxErrorBlock ifSendsUnimplementedSelectors: sendsUnimplementedSelectorsBlock ifValid: validBlock [

	| messagePattern compilationResult |

	messagePattern := '_ '.
	EsParser parse: messagePattern , code class: UndefinedObject
		errorHandler: (GeminiParserErrorHandler block: [ :error :sourcePosition |
			^ syntaxErrorBlock value: error value: sourcePosition - messagePattern size ])
		ifFail: [ ].
	compilationResult := Compiler compileForEvaluation: code
		environment: (Compiler nameEnvironmentForClass: UndefinedObject)
		errorHandler: EsSilentErrorHandler new.
	compilationResult wasSuccessful ifTrue: [
		| previousPropertyValue mainResult |
		previousPropertyValue := CcUnimplementedMethods propertyValueAt: #scanEntireImage.
		[
			CcUnimplementedMethods propertyValueAt: #scanEntireImage put: true.
			mainResult := (CtMethodEngine on: { compilationResult method } with: { CcUnimplementedMethods }) computeAndReportProgressTo: nil.
		] ensure: [ 
			CcUnimplementedMethods propertyValueAt: #scanEntireImage put: previousPropertyValue ].
		mainResult allMeasurements ifNotEmpty: [ :measurements |
			^ sendsUnimplementedSelectorsBlock value: (measurements first results first details collect: [ :detail | detail first ]) ] ].
	^ validBlock cull: code
]

{ #category : 'Not categorized' }
GeminiFunctionValidateCode >> validate: code ifValid: validBlock [

	^ self validate: code
		ifSyntaxError: [ :error :sourcePosition |
			EsOrderedDictionary with: 'error' ->
				('Syntax error in given code at position ' , sourcePosition asString , ': ' , error)]
		ifSendsUnimplementedSelectors: [ :selectors |
			EsOrderedDictionary with: 'error' ->
				('Sends selectors that have no implementors: ' , ((selectors sorted collect: [ :selector | selector printString]) joinUsing: ', ')) ]
		ifValid: validBlock
]
