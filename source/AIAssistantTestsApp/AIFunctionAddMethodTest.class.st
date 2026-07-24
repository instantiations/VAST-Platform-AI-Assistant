Class {
	#name : 'AIFunctionAddMethodTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

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
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Sends selectors that have no implementors: #someNonExistentMessageSendWhichNobodyImplements'.
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

{ #category : 'Testing' }
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
