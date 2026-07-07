Class {
	#name : 'AIFunctionAddMethod',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionAddMethod >> applicationParameterDefinition [

	^ AIFunctionParameterRequired name: 'application'
			type: AIFunctionParameterTypeString new
			description: 'The name of the application to place the method in.'.
]

{ #category : 'Actions' }
AIFunctionAddMethod >> applyFunctionTo: arguments in: context [

	| className source appName app isClassSide categories isPrivate change validationResult |
	
	className := arguments at: 'class'.	
	isClassSide := self isClassSideParametervalue: (arguments at: 'side' ifAbsent: [ 'instance' ]).
	isClassSide ifNil:[ ^EsOrderedDictionary with: 'error' -> ('Invalid value for parameter ''side'': %1' bindWith: (arguments at: 'side')) ].
	source := (arguments at: 'source') asSBString ifNil:[ ^EsOrderedDictionary with: 'error' -> ('Invalid characters in source. Only extended ASCII allowed.' ) ]. 
	categories := arguments at: 'categories' ifAbsent: [ nil ].
	isPrivate := arguments at: 'is_private' ifAbsent: [ false ].
	appName := arguments at: 'application' ifAbsent: [ nil ].
	
	validationResult := self validate: source from: 1 forEvaluation: false context: context.
	(validationResult includesKey: 'error') ifTrue: [ ^ validationResult ].
	
	appName
		ifNil: [ 
			"The application name should only have been ommitted when changing existing methods, but we have a fallback error here anyway"
			(self classNamed: className) ifNil:[  ^ EsOrderedDictionary with: 'error' -> ('Application %1 not found' bindWith: appName) ] ]
		ifNotNil: [
			app := self applicationNamed: appName.
			app ifNil: [ ^ EsOrderedDictionary with: 'error' -> ('Application %1 not found' bindWith: appName) ]].
			
	change := AIAddMethodChange compile: source inClassNamed: className asSymbol protocols: (categories ifNil: [ #() ]) application: app isPrivate: isPrivate isClassSide: isClassSide.
	
	categories ifNil: [
		| methodClass existingMethod |
		methodClass := change changeClass.
		methodClass ifNotNil: [
			existingMethod := methodClass compiledMethodAt: change selector ifAbsent: [nil].
			existingMethod ifNotNil: [
				change protocols: (methodClass categoriesFor: change selector)]]].
	
	"If we did not specify an app, then use the default rules for specifying it. This is necessary to be able to show the change classified in the refactory changes browser"
	app ifNil: [ change application: change defaultApplicationForMethod ].
	context addRefactoryChange: change.
	
	^ EsOrderedDictionary with: 'result' -> 'Successfully created change'
]

{ #category : 'Accessing' }
AIFunctionAddMethod >> category [

	^ 'Code Modification'
]

{ #category : 'Accessing' }
AIFunctionAddMethod >> description [

	^ 'Adds a new method to a class. Note: The generated method source code will be automatically displayed to the user. Do not output the code in your text response, but you can provide a textual explanation of the changes.'
]

{ #category : 'Accessing' }
AIFunctionAddMethod >> name [

	^ 'add_method'
]

{ #category : 'Accessing' }
AIFunctionAddMethod >> parameters [

	^ {
		AIFunctionParameterRequired name: 'class'
			type: AIFunctionParameterTypeString new
			description: 'The name of the class to add the method to'.
		AIFunctionParameterRequired name: 'source'
			type: AIFunctionParameterTypeString new
			description: 'The source code of the method. Only extended ASCII characters allowed.'.
		AIFunctionParameterOptional name: 'categories'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'The categories to classify the method under'.
		AIFunctionParameterOptional name: 'is_private'
			type: AIFunctionParameterTypeBoolean new
			description: 'True if the method should be private, false otherwise. Defaults to false.'.
		self applicationParameterDefinition.
		AIFunctionParameterOptional name: 'side'
			type: AIFunctionParameterTypeString new
			description: '''instance'' for an instance method, ''class'' for a class method. Defaults to ''instance''.' }
]
