Class {
	#name : 'AIFunctionAddMethodTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Test subjects',
  #vaVisibility : 'private' }
AIFunctionAddMethodTest >> dummyPrivateMethod [
	^ 1
]

{ #category : 'Test subjects' }
AIFunctionAddMethodTest >> dummyPublicMethod [
	^ 1
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testAddMethodFailsIfMethodExists [

	| args result context |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionAddMethodTest'.
	args at: 'source' put: 'dummyPrivateMethod ^2'.
	args at: 'application' put: 'AIAssistantTestsApp'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionAddMethod withArguments: args inContext: context.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Method already exists. Use change_method instead.'.
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testInvalidClassName [

	| args result |
	args := Dictionary new.
	args at: 'class' put: '123Class'.
	args at: 'source' put: 'foo ^1'.
	result := self applyFunction: AIFunctionAddMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid class name: 123Class. Provide a valid Smalltalk class name.'
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testInvalidReferenceToProposedClassInstVarOnInstanceSide [

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
	args at: 'source' put: 'testMethod ^ newClassInstVar'.
	args at: 'application' put: 'AIAssistantTestsApp'.

	result := self applyFunction: AIFunctionAddMethod withArguments: args inContext: context.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''newClassInstVar'''.
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testSyntaxErrorInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionAddMethodTest'.
	args at: 'source' put: 'foo | a
		a := 1. "Missing pipe for closing temps"
		^ a'.
	args at: 'application' put: 'AIAssistantTestsApp'.
	result := self applyFunction: AIFunctionAddMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: ('Syntax error in given code at position *: "|" expected' match: (result at: 'error')).
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testUnknownMessageSendInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionAddMethodTest'.
	args at: 'source' put: 'foo ^ self someNonExistentMessageSendWhichNobodyImplements'.
	args at: 'application' put: 'AIAssistantTestsApp'.
	result := self applyFunction: AIFunctionAddMethod withArguments: args.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'warning').
	self assert: (result at: 'warning') equals: 'Sends selectors that have no implementors: #someNonExistentMessageSendWhichNobodyImplements'.
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testUnknownVariableInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionAddMethodTest'.
	args at: 'source' put: 'foo ^ SomeNonExistentVariableWhichNobodyDefines'.
	args at: 'application' put: 'AIAssistantTestsApp'.
	result := self applyFunction: AIFunctionAddMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''SomeNonExistentVariableWhichNobodyDefines'''.
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testValidClassSideMethod [
	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionAddMethodTest'.
	args at: 'side' put: 'class'.
	args at: 'source' put: 'foo ^1'.
	args at: 'application' put: 'AIAssistantTestsApp'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionAddMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionAddMethodTest.
	self assert: change isMeta.
	self assert: change selector equals: #foo.
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testValidMethod [

	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionAddMethodTest'.
	args at: 'source' put: 'foo ^1'.
	args at: 'application' put: 'AIAssistantTestsApp'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionAddMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionAddMethodTest.
	self assert: change selector equals: #foo.
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testValidReferenceToProposedClassInstVar [

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
	args at: 'source' put: 'testMethod ^ newClassInstVar'.
	args at: 'application' put: 'AIAssistantTestsApp'.

	result := self applyFunction: AIFunctionAddMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
]

{ #category : 'Tests' }
AIFunctionAddMethodTest >> testValidReferenceToProposedPoolVar [
	| classChange context args result |
	classChange := AIAddClassChange
		definition: 'Object subclass: #AITestDummyClass
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: ''SwapperConstants'' '
		application: nil.
	context := self contextWithChange: classChange.
	args := Dictionary new.
	args at: 'class' put: 'AITestDummyClass'.
	args at: 'source' put: 'testMethod ^ InvalidFileHandle'.
	args at: 'application' put: 'AIAssistantTestsApp'.
	result := self applyFunction: AIFunctionAddMethod withArguments: args inContext: context.
	self assert: (result includesKey: 'result').
	self assert: (result at: 'result') equals: 'Successfully created change'.
	self deny: (result includesKey: 'error')
]
