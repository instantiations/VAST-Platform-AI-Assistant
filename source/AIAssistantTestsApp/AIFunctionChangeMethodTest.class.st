Class {
	#name : 'AIFunctionChangeMethodTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testInvalidClassName [

	| args result |
	args := Dictionary new.
	args at: 'class' put: '123Class'.
	args at: 'source' put: 'foo ^1'.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid class name: 123Class. Provide a valid Smalltalk class name.'
]

{ #category : 'accessing' }
AIFunctionChangeMethodTest >> testSyntaxErrorInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'foo | a
		a := 1. "Missing pipe for closing temps"
		^ a'.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: ('Syntax error in given code at position *: "|" expected' match: (result at: 'error')).
]

{ #category : 'accessing' }
AIFunctionChangeMethodTest >> testUnknownMessageSendInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'foo ^ self someNonExistentMessageSendWhichNobodyImplements'.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Sends selectors that have no implementors: #someNonExistentMessageSendWhichNobodyImplements'.
]

{ #category : 'accessing' }
AIFunctionChangeMethodTest >> testUnknownVariableInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'foo ^ SomeNonExistentVariableWhichNobodyDefines'.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''SomeNonExistentVariableWhichNobodyDefines'''.
]

{ #category : 'Testing' }
AIFunctionChangeMethodTest >> testValidClassSideMethod [
	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'side' put: 'class'.
	args at: 'source' put: 'foo ^1'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionChangeMethodTest.
	self assert: change isMeta.
	self assert: change selector equals: #foo.
]

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testValidMethod [

	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'foo ^1'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionChangeMethodTest.
	self assert: change selector equals: #foo.
]
