Class {
	#name : 'AIFunctionAddClass',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionAddClass >> applicationParameterDefinition [

	^	AIFunctionParameterOptional name: 'application'
			type: AIFunctionParameterTypeString new
			description: 'The name of the application to define the class in. Defaults to the default application.'.
]

{ #category : 'Actions' }
AIFunctionAddClass >> applyFunctionTo: arguments in: context [

	| superclassName className instVars classInstVars classVars pools appName app type definition change |

	superclassName := arguments at: 'superclass'.
	className := arguments at: 'class_name'.
	instVars := arguments at: 'instance_variables' ifAbsent: [#()].
	classInstVars := arguments at: 'class_instance_variables' ifAbsent: [#()].
	classVars := arguments at: 'class_variables' ifAbsent: [#()].
	pools := arguments at: 'pool_dictionaries' ifAbsent: [#()].
	type := arguments at: 'class_type' ifAbsent: ['normal'].
	appName := arguments at: 'application' ifAbsent: [self defaultApplicationNameForClassName: className].

	(self checkClassName: className) ifNotNil: [:errorResult | ^errorResult].
	(self checkClassType: type) ifNotNil: [:errorResult | ^ errorResult ].
	(self checkSuperclass: superclassName context: context) ifNotNil: [:errorResult | ^errorResult].

	(#('variableByte' 'variableWord' 'variableLong') includes: type)
		ifTrue: [
			instVars isEmpty
				ifFalse: [ ^EsOrderedDictionary with: 'error' -> ('Instance variables are not supported for class type %1' bindWith: type)]].

	app := self applicationNamed: appName.
	app ifNil: [^EsOrderedDictionary with: 'error' -> ('Application %1 not found' bindWith: appName)].

	definition :=
		(self
			definitionStringFor: className
			type: type
			superclass: superclassName
			instVars: instVars
			classInstVars: classInstVars
			classVars: classVars
			pools: pools)
				asSBString.
	definition ifNil: [
		^EsOrderedDictionary with: 'error' -> ('Invalid characters in definition. Only extended ASCII allowed.')].

	change := AIAddClassChange definition: definition application: app.
	change validateDefinition ifNotNil:[ :string | ^ EsOrderedDictionary with: 'error' -> string ].
	
	context addRefactoryChange: change.
	^EsOrderedDictionary with: 'result' -> 'Successfully created change'
]

{ #category : 'Accessing' }
AIFunctionAddClass >> category [

	^ 'Code Modification'
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionAddClass >> checkClassType: type [

	(#('normal' 'variable' 'variableByte' 'variableWord' 'variableLong') includes: type)
		ifFalse: [^EsOrderedDictionary with: 'error' -> ('Invalid class type %1. Should be one of: normal, variable, variableByte, variableWord, variableLong.' bindWith: type)].
	^nil
]

{ #category : 'accessing' }
AIFunctionAddClass >> checkSuperclass: superclassName context: context [

	superclassName = 'nil' ifTrue: [ ^ nil ].

	(self classNamed: superclassName) ifNotNil: [ ^ nil ].
	(context notNil and: [ context proposedClasses includes: superclassName ]) ifTrue: [ ^ nil ].
	
	^ EsOrderedDictionary with: 'error' -> ('Unknown superclass: %1' bindWith: superclassName)
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionAddClass >> classCreationKeywordFor: type [

	type = 'normal' ifTrue:[ ^ 'subclass:' ].
	type = 'variable' ifTrue: [ ^ 'variableSubclass:'].
	type = 'variableByte' ifTrue: [ ^ 'variableByteSubclass:'].
	type = 'variableWord' ifTrue: [ ^ 'variableWordSubclass:'].
	type = 'variableLong' ifTrue: [ ^ 'variableLongSubclass:'].
	Error signal: 'Invalid class creation keyword'
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionAddClass >> defaultApplicationNameForClassName: className [

	^  System defaultApplication name
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIFunctionAddClass >> definitionStringFor: className type: type superclass: superclassName instVars: instVars classInstVars: classInstVars classVars: classVars pools: pools [

	| keyword |
	
	keyword := self classCreationKeywordFor: type.
	^	(String streamContents: [:stream |
			stream
				cr;
				nextPutAll: superclassName;
				space;
				nextPutAll: keyword;
				space;
				nextPutAll: '#';
				nextPutAll: className;
				cr;
				nextPutAll: '    classInstanceVariableNames: '''.
			classInstVars do: [:each | stream nextPutAll: each; space].
			stream
				nextPutAll: '''';
				cr.

			(#('variableByte' 'variableWord' 'variableLong') includes: type)
				ifFalse: [
					stream nextPutAll: '    instanceVariableNames: '''.
					instVars do: [:each | stream nextPutAll: each; space].
					stream
						nextPutAll: '''';
						cr].

			stream nextPutAll: '    classVariableNames: '''.
			classVars do: [:each | stream nextPutAll: each; space].
			stream
				nextPutAll: '''';
				cr;
				nextPutAll: '    poolDictionaries: '''.
			pools do: [:each | stream nextPutAll: each; space].
			stream nextPutAll: ''''])
]

{ #category : 'Accessing' }
AIFunctionAddClass >> description [

	^ 'Adds a new class. Note: The generated class definition will be automatically displayed to the user in a code block. Do not output the code in your text response, but you can provide a textual explanation of the changes.'
]

{ #category : 'Accessing' }
AIFunctionAddClass >> name [

	^ 'add_class'
]

{ #category : 'Accessing' }
AIFunctionAddClass >> parameters [

	^ {
		AIFunctionParameterRequired name: 'superclass'
			type: AIFunctionParameterTypeString new
			description: 'The name of the superclass'.
		AIFunctionParameterRequired name: 'class_name'
			type: AIFunctionParameterTypeString new
			description: 'The name of the new class'.
		AIFunctionParameterOptional name: 'instance_variables'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'The instance variable names'.
		AIFunctionParameterOptional name: 'class_instance_variables'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'The class instance variable names'.
		AIFunctionParameterOptional name: 'class_variables'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'The class variable names'.
		AIFunctionParameterOptional name: 'pool_dictionaries'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'The pool dictionary names'.
		AIFunctionParameterOptional name: 'class_type'
			type: AIFunctionParameterTypeString new
			description: 'The type of class (normal, variable, variableByte, variableWord, variableLong). Defaults to normal.'.
		self applicationParameterDefinition.
	}
]
