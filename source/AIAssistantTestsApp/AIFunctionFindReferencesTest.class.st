Class {
	#name : 'AIFunctionFindReferencesTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'sample methods',
  #vaVisibility : 'private' }
AIFunctionFindReferencesTest class >> mySampleTestSelectorOnTheClassSide [
	^AIFunctionFindReferencesTest basicNew mySampleTestSelectorOnTheInstanceSide
]

{ #category : 'sample methods',
  #vaVisibility : 'private' }
AIFunctionFindReferencesTest >> mySampleTestSelectorOnTheInstanceSide [
	^AIFunctionFindReferencesTest mySampleTestSelectorOnTheClassSide
]

{ #category : 'Tests' }
AIFunctionFindReferencesTest >> testMaxResultsWarning [

	|args result context |
	args := Dictionary new.
	args at: 'variable_name' put: 'AIFunctionFindReferencesTest'.
	args at: 'with_source' put: false.
	args at: 'applications' put: #('AIAssistantTestsApp').
	context := AIFunctionCallContext model: (AIAbstractModel name: 'Test contextSize' label: 'A' provider: AIAbstractModelProvider new contextWindowSize: 0) filePaths: #() codeChanges: #().
	result := AIFunctionFindReferences new applyFunctionTo: args in: context. 
	self assert: (result at: 'methods') notEmpty.
	"With contextSize 0, maxResults should also be 0"
	self assert:  (result at: 'warning' ifAbsent: [nil]) notNil
]

{ #category : 'Tests' }
AIFunctionFindReferencesTest >> testReferencesApplicationScoped [

	|args result|
	args := Dictionary new.
	args at: 'variable_name' put: 'AIFunctionFindReferencesTest'.
	args at: 'with_source' put: false.
	args at: 'applications' put: #('AIAssistantTestsApp').
	result := AIFunctionFindReferences new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	"One instance method and one class method referencing the class"
	self assert:  (result at: 'methods') size equals: 2.
	args at: 'applications' put: #('Core').
	result := AIFunctionFindReferences new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindReferencesTest >> testReferencesClassScoped [

	|args result sample|
	args := Dictionary new.
	args at: 'variable_name' put: 'AIFunctionFindReferencesTest'.
	args at: 'with_source' put: false.
	args at: 'classes' put: #('AIFunctionFindReferencesTest').
	result := AIFunctionFindReferences new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') size equals: 2.
	args at: 'classes' put: #('Object').
	result := AIFunctionFindReferences new applyFunctionTo: args in: nil. 
	self assert: (result at: 'methods') isEmpty.

]

{ #category : 'Tests' }
AIFunctionFindReferencesTest >> testReferencesWithSource [

	|args result |
	args := Dictionary new.
	args at: 'variable_name' put: 'AIFunctionFindReferencesTest'.
	args at: 'with_source' put: true.
	
	result := AIFunctionFindReferences new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	"One instance method and one class method referencing the class"
	self assert:  (result at: 'methods') size equals: 2.
	"selector/class tested in testReferencesWithoutSource, only check we send with source"
	(result at: 'methods') do: [:method | 
		self assert: (method at: 'source' ifAbsent: [nil]) notNil	]

]

{ #category : 'Tests' }
AIFunctionFindReferencesTest >> testReferencesWithoutSource [

	|args result |
	args := Dictionary new.
	args at: 'variable_name' put: 'AIFunctionFindReferencesTest'.
	args at: 'with_source' put: false.
	
	result := AIFunctionFindReferences new applyFunctionTo: args in: nil. 
	self deny: (result at: 'methods') isEmpty.
	"One instance method and one class method referencing the class"
	self assert:  (result at: 'methods') size equals: 2.
	(result at: 'methods') do: [:method | 
		(method at: 'side') = 'class'
			ifTrue: [self assert: (method at: 'selector') equals: #mySampleTestSelectorOnTheClassSide asString].
		(method at: 'side') = 'instance'
			ifTrue: [self assert: (method at: 'selector') equals: #mySampleTestSelectorOnTheInstanceSide asString].
		self assert: (method at: 'source' ifAbsent: [nil]) isNil
		]

]
