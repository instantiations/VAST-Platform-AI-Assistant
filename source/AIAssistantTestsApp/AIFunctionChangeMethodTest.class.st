Class {
	#name : 'AIFunctionChangeMethodTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Testing' }
AIFunctionChangeMethodTest class >> dummyClassMethod [
	^ 1
]

{ #category : 'Test subjects',
  #vaVisibility : 'private' }
AIFunctionChangeMethodTest >> dummyPrivateMethod [
	^ 1
]

{ #category : 'Test subjects' }
AIFunctionChangeMethodTest >> dummyPublicMethod [
	^ 1
]

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testChangeOverridesVisibilityWhenProvided [

	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'dummyPrivateMethod ^2'.
	args at: 'is_private' put: false.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	change := context codeChanges first.
	self deny: change isPrivate.

	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'dummyPublicMethod ^2'.
	args at: 'is_private' put: true.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	change := context codeChanges first.
	self assert: change isPrivate.
]

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testChangePreservesVisibilityWhenNotProvided [

	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'dummyPrivateMethod ^2'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	change := context codeChanges first.
	self assert: change isPrivate.

	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'dummyPublicMethod ^2'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	change := context codeChanges first.
	self deny: change isPrivate.
]

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

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testMethodDoesNotExist [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'someMethodThatDoesNotExist ^1'.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Method does not exist. Use add_method instead.'
]

{ #category : 'Tests' }
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

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testUnknownMessageSendInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'testUnknownMessageSendInMethodIsFlagged ^ self someNonExistentMessageSendWhichNobodyImplements'.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'warning').
	self assert: (result at: 'warning') equals: 'Sends selectors that have no implementors: #someNonExistentMessageSendWhichNobodyImplements'.
]

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testUnknownVariableInMethodIsFlagged [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'foo ^ SomeNonExistentVariableWhichNobodyDefines'.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'References unknown variables, classes or globals: ''SomeNonExistentVariableWhichNobodyDefines'''.
]

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testValidClassSideMethod [
	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'side' put: 'class'.
	args at: 'source' put: 'dummyClassMethod ^1'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionChangeMethodTest.
	self assert: change isMeta.
	self assert: change selector equals: #dummyClassMethod.
]

{ #category : 'Tests' }
AIFunctionChangeMethodTest >> testValidMethod [

	| args result context change |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionChangeMethodTest'.
	args at: 'source' put: 'dummyPublicMethod ^1'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionChangeMethodTest.
	self assert: change selector equals: #dummyPublicMethod.
]
