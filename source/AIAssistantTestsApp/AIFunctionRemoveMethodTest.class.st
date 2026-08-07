Class {
	#name : 'AIFunctionRemoveMethodTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionRemoveMethodTest >> testClassDoesNotExist [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'NonExistentClassXYZ'.
	args at: 'selector' put: 'foo'.
	result := self applyFunction: AIFunctionRemoveMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Class NonExistentClassXYZ not found'.
]

{ #category : 'Tests' }
AIFunctionRemoveMethodTest >> testClassSideMethodRemoval [
	| args result context change methodApp |
	args := Dictionary new.
	args at: 'side' put: 'class'.
	args at: 'class' put: 'Object'.
	args at: 'selector' put: 'initializeAfterLoad'.
	
	context := self emptyContext.
	result := self applyFunction: AIFunctionRemoveMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	change := context codeChanges first.
	self assert: change changeClassName equals: #Object.
	self assert: change selector equals: #initializeAfterLoad.
	self assert: change isMeta.

	methodApp := (Object class compiledMethodAt: #initializeAfterLoad) application.
	self assert: change application equals: methodApp.
	self assert: Object controller equals: methodApp 
]

{ #category : 'Tests' }
AIFunctionRemoveMethodTest >> testCorrectApplicationClassification [
	| args result context change methodApp |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionCallContext'.
	args at: 'selector' put: 'proposedClasses'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionRemoveMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	change := context codeChanges first.
	
	methodApp := (AIFunctionCallContext compiledMethodAt: #proposedClasses) application.
	self assert: AIFunctionCallContext controller ~= methodApp description: 'The class application should be different from the method application'.
	self assert: change application equals: methodApp.
]

{ #category : 'Tests' }
AIFunctionRemoveMethodTest >> testMethodDoesNotExist [
	| args result |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionRemoveMethodTest'.
	args at: 'selector' put: 'nonExistentMethodXYZ'.
	result := self applyFunction: AIFunctionRemoveMethod withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'AIFunctionRemoveMethodTest does not implement selector nonExistentMethodXYZ.'.
]

{ #category : 'Tests' }
AIFunctionRemoveMethodTest >> testValidMethodRemoval [
	| args result context change methodApp |
	args := Dictionary new.
	args at: 'class' put: 'AIFunctionRemoveMethodTest'.
	args at: 'selector' put: 'testValidMethodRemoval'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionRemoveMethod withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionRemoveMethodTest.
	self assert: change selector equals: #testValidMethodRemoval.
	self deny: change isMeta.

	methodApp := (AIFunctionRemoveMethodTest compiledMethodAt: #testValidMethodRemoval) application.
	self assert: change application equals: methodApp.
	self assert: AIFunctionRemoveMethodTest controller equals: methodApp 
]
