Class {
	#name : 'AIFunctionValidateCodeTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testClassSideCanAccessClassVariables [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'Object'.
	args at: 'side' put: 'class'.
	args at: 'code' put: '^ Dependents'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testClassSideCannotAccessInstanceVariables [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'Association'.
	args at: 'side' put: 'class'.
	args at: 'code' put: '^ key'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''key'''.
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testExistingClassStateIsValid [
	"Test references to existing instance variables of the target class.
	Association has #key and #value instance variables."
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'Association'.
	args at: 'code' put: 'key := value. ^ key'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testExistingGlobalIsValid [
	| args result |
	args := Dictionary new.
	args at: 'code' put: '^ String'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testExistingPoolDictionaryVariableIsValid [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionValidateCodeTest'.
	"This class inherits from Object, which has EsSystemPrimitives pool.
	We can test a variable from EsSystemPrimitives, e.g., NlsCatKRN."
	args at: 'code' put: '^ NlsCatKRN'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testInvalidMessageSendIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'code' put: '^ self someNonExistentMessageSendWhichNobodyImplements'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Sends selectors that have no implementors: #someNonExistentMessageSendWhichNobodyImplements'.
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testInvalidReferenceIsFlagged [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			instanceVariableNames: ''newInstVar''
			classVariableNames: ''NewClassVar''
			poolDictionaries: ''CldtConstants'' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'class' put: 'AITestDummyClass'.
	args at: 'code' put: '^ SomeNonExistentVariable'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''SomeNonExistentVariable'''.
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testInvalidReferenceToProposedClassInstVarOnInstanceSide [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			classInstanceVariableNames: ''newClassInstVar''
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: '''' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'class' put: 'AITestDummyClass'.
	args at: 'side' put: 'instance'.
	args at: 'code' put: '^ newClassInstVar'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''newClassInstVar'''.
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testProposedMessageSendIsValid [
	| methodChange context args result |
	methodChange := AIAddMethodChange 
		compile: 'someProposedMessageSendWhichNobodyImplements ^ self' 
		inClassNamed: #Object 
		protocols: #() 
		application: nil 
		isPrivate: false 
		isClassSide: false.
	context := self contextWithChange: methodChange.
	args := Dictionary new.
	args at: 'code' put: '^ self someProposedMessageSendWhichNobodyImplements'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testPseudoVariableThisContextIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'code' put: '^ thisContext'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''thisContext'''.
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testPseudoVariablesAndLocalsAreValid [
	| args result |
	args := Dictionary new.
	args at: 'code' put: '| temp |
		temp := 1.
		^ [ :blockArg | | blockTemp | 
			blockTemp := blockArg. 
			self. super. true. false. nil. ]'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testSyntaxErrorIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'code' put: '| a
		a := 1. "Missing pipe for closing temps"
		^ a'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: ('Syntax error in given code at position *: "|" expected' match: (result at: 'error')).
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testValidMessageSend [
	| args result |
	args := Dictionary new.
	args at: 'code' put: '^ self printString'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testValidReferenceToExistingClassInstVar [

	| context args result |
	context := self emptyContext.

	args := Dictionary new.
	args at: 'class' put: 'Object'.
	args at: 'side' put: 'class'.
	"Object class inherits from Class -> ClassDescription -> Behavior. Behavior defines 'methodDictionary'."
	args at: 'code' put: '^ methodDictionary'. 
	
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testValidReferenceToProposedClass [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: '''' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'code' put: '^ AITestDummyClass'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testValidReferenceToProposedClassInstVar [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			classInstanceVariableNames: ''newClassInstVar''
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: '''' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'class' put: 'AITestDummyClass'.
	args at: 'side' put: 'class'.
	args at: 'code' put: '^ newClassInstVar'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testValidReferenceToProposedClassVar [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			instanceVariableNames: ''''
			classVariableNames: ''NewClassVar''
			poolDictionaries: '''' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'class' put: 'AITestDummyClass'.
	args at: 'code' put: '^ NewClassVar'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testValidReferenceToProposedInstVar [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			instanceVariableNames: ''newInstVar''
			classVariableNames: ''''
			poolDictionaries: '''' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'class' put: 'AITestDummyClass'.
	args at: 'code' put: '^ newInstVar'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]

{ #category : 'Testing' }
AIFunctionValidateCodeTest >> testValidReferenceToProposedPoolVar [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: ''CldtConstants'' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'class' put: 'AITestDummyClass'.
	args at: 'code' put: '^ LineDelimiter'.
	result := self applyFunction: AIFunctionValidateCode withArguments: args inContext: context.
	self assert: (result includesKey: 'valid').
	self assert: (result at: 'valid').
]
