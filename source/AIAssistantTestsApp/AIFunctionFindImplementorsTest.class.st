Class {
	#name : 'AIFunctionFindImplementorsTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Sample methods',
  #vaVisibility : 'private' }
AIFunctionFindImplementorsTest class >> mySampleImplementorOnTheClassSide [
	"Just a sample class method to test senders/implementors"
	^self basicNew mySampleImplementorOnTheInstanceSide
]

{ #category : 'Sample methods',
  #vaVisibility : 'private' }
AIFunctionFindImplementorsTest >> mySampleImplementorOnTheInstanceSide [
	"Just a sample class method to test senders/implementors"
	^self class mySampleImplementorOnTheClassSide
]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testApplicationScoped [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleImplementorOnTheClassSide' 'mySampleImplementorOnTheInstanceSide').
	args at: 'with_source' put: false.
	args at: 'applications' put: #('AIAssistantTestsApp').
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'class').
	self assert: (sample at: 'class') = self class name asString .
	args at: 'applications' put: #('Core').
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testClassMethodWithSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleImplementorOnTheClassSide' 'mySampleNonExistentImplementorOnTheClassSide').
	args at: 'with_source' put: true.
	
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'class'.
	self assert: (sample at: 'application') equals: 'AIAssistantTestsApp'.
]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testClassMethodWithoutSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleImplementorOnTheClassSide' 'mySampleNonExistentImplementorOnTheClassSide').
	args at: 'with_source' put: false.
	
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self deny: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'class'.
	self assert: (sample at: 'application') equals: 'AIAssistantTestsApp'.
]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testClassScoped [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleImplementorOnTheClassSide' 'mySampleImplementorOnTheClassSide2').
	args at: 'with_source' put: false.
	args at: 'classes' put: #('AIFunctionFindImplementorsTest').
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') size equals: 1.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'class').
	self assert: (sample at: 'class') = self class name asString .
	args at: 'classes' put: #('Object').
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testClassScopedWithWildcards [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleImplementorOnThe*Side' ).
	args at: 'with_source' put: false.
	args at: 'classes' put: #('AIFunctionFindImplementorsTest').
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') size equals: 2.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'class').
	self assert: (sample at: 'class') = self class name asString .
	args at: 'classes' put: #('Object').
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testInstanceMethodWithSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleImplementorOnTheInstanceSide' 'mySampleImplementorOnTheInstanceSide2').
	args at: 'with_source' put: true.
	
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'instance'.
	self assert: (sample at: 'application') equals: 'AIAssistantTestsApp'.
]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testInstanceMethodWithoutSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleImplementorOnTheInstanceSide' 'mySampleImplementorOnTheInstanceSide2').
	args at: 'with_source' put: false.
	
	result := AIFunctionFindImplementors new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self deny: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'instance'.
	self assert: (sample at: 'application') equals: 'AIAssistantTestsApp'.
]

{ #category : 'Tests' }
AIFunctionFindImplementorsTest >> testMaxResultsWarning [

	| args result context |

	args := Dictionary new.
	args
		at: 'selectors'
		put: #('mySampleImplementorOnTheInstanceSide' 'mySampleImplementorOnTheInstanceSide2').
	args at: 'with_source' put: false.
	context :=
		AIFunctionCallContext
			model: (AIAbstractModel name: 'Test contextSize' label: 'A' provider: AIAbstractModelProvider new contextWindowSize: 0)
			filePaths: #()
			codeChanges: #().
	result := AIFunctionFindImplementors new applyFunctionTo: args in: context.
	self assert: (result at: 'warning' ifAbsent: [nil]) notNil
]
