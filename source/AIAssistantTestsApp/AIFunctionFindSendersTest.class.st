Class {
	#name : 'AIFunctionFindSendersTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'sample methods',
  #vaVisibility : 'private' }
AIFunctionFindSendersTest class >> mySampleSenderOnTheClassSide [
	"Just a sample class method to test senders/implementors"
	^self basicNew mySampleSenderOnTheInstanceSide
]

{ #category : 'sample methods',
  #vaVisibility : 'private' }
AIFunctionFindSendersTest class >> mySampleSenderOnTheClassSide2 [
	"Just a sample class method to test senders/implementors"
	^self basicNew mySampleSenderOnTheInstanceSide2
]

{ #category : 'sample methods',
  #vaVisibility : 'private' }
AIFunctionFindSendersTest >> mySampleSenderOnTheInstanceSide [
	"Just a sample class method to test senders/implementors"
	^self class mySampleSenderOnTheClassSide
]

{ #category : 'sample methods',
  #vaVisibility : 'private' }
AIFunctionFindSendersTest >> mySampleSenderOnTheInstanceSide2 [
	"Just a sample class method to test senders/implementors"
	^self class mySampleSenderOnTheClassSide2
]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testApplicationScoped [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnTheInstanceSide' 'mySampleSenderOnTheInstanceSide2' 'mySampleSenderOnTheClassSide' 'mySampleSenderOnTheClassSide2' 'myNonExistentClassSideMethod').
	args at: 'with_source' put: false.
	args at: 'applications' put: #('AIAssistantTestsApp').
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') size equals: 4.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'class').
	self assert: (sample at: 'class') = self class name asString .
	args at: 'applications' put: #('Core').
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testClassMethodWithSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnTheInstanceSide' 'myNonExistentClassSideMethod').
	args at: 'with_source' put: true.
	
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'class'.
]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testClassMethodWithoutSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnTheInstanceSide' 'myNonExistentClassSideMethod').
	args at: 'with_source' put: false.
	
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self deny: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'class'.
]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testClassScoped [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnTheClassSide' 'mySampleSenderOnTheClassSide2').
	args at: 'with_source' put: false.
	args at: 'classes' put: #('AIFunctionFindSendersTest').
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') size equals: 2.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'class').
	self assert: (sample at: 'class') = self class name asString .
	args at: 'classes' put: #('Object').
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testClassScopedWithWildcards [

	|args result|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnThe*Side' 'mySampleSenderOnThe*Side2').
	args at: 'with_source' put: false.
	args at: 'classes' put: #('AIFunctionFindSendersTest').
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') size equals: 4.
	args at: 'classes' put: #('Object').
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testInstanceMethodWithSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnTheClassSide' 'myNonExistentClassSideMethod').
	args at: 'with_source' put: true.
	
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self assert: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'instance'.
]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testInstanceMethodWithoutSource [

	|args result sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnTheClassSide' 'myNonExistentClassSideMethod').
	args at: 'with_source' put: false.
	
	result := AIFunctionFindSenders new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	sample := (result at: 'methods') first.
	self deny: (sample includesKey: 'source').
	self assert: (sample at: 'class') equals: self class name asString.
	self assert: (sample at: 'side') equals: 'instance'.
]

{ #category : 'Tests' }
AIFunctionFindSendersTest >> testMaxResultsWarning [

	|args result context sample|
	args := Dictionary new.
	args at: 'selectors' put: #('mySampleSenderOnTheClassSide' 'myNonExistentClassSideMethod').
	args at: 'with_source' put: false.
	context := AIFunctionCallContext model: (AIAbstractModel name: 'Test contextSize' label: 'A' provider: AIAbstractModelProvider new contextWindowSize: 0) filePaths: #() codeChanges: #().
	result := AIFunctionFindSenders new applyFunctionTo: args in: context. 
	self assert: (result at: 'warning' ifAbsent: [nil]) notNil
]
