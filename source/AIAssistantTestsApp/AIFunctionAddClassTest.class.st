Class {
	#name : 'AIFunctionAddClassTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionAddClassTest >> testApplicationNotFound [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample2'.
	args at: 'superclass' put: 'Object'.
	args at: 'application' put: 'NonExistentApp123'.
	result := self applyFunction: AIFunctionAddClass withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Application NonExistentApp123 not found'
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testDifferentClassTypes [
	| args result context change types |
	types := Dictionary new.
	types at: 'variable' put: 'variableSubclass:'.
	types at: 'variableByte' put: 'variableByteSubclass:'.
	types at: 'variableWord' put: 'variableWordSubclass:'.
	types at: 'variableLong' put: 'variableLongSubclass:'.
	
	types keysAndValuesDo: [:type :keyword |
		args := Dictionary new.
		args at: 'class_name' put: 'AIFunctionAddClassSample6'.
		args at: 'superclass' put: 'Object'.
		args at: 'class_type' put: type.
		context := self emptyContext.
		result := self applyFunction: AIFunctionAddClass withArguments: args inContext: context.
		
		self deny: (result includesKey: 'error').
		change := context codeChanges first.
		self assert: (change definition includesSubstring: keyword).
		(#('variableByte' 'variableWord' 'variableLong') includes: type)
			ifTrue: [ self deny: (change definition includesSubstring: 'instanceVariableNames:') ]
			ifFalse: [ self assert: (change definition includesSubstring: 'instanceVariableNames:') ].
	].
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testInvalidCharacters [

	| args result invalidVar |

	invalidVar := UnicodeString escaped: 'invalid\u{100}var'.
	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample3'.
	args at: 'superclass' put: 'Object'.
	args at: 'instance_variables' put: (Array with: invalidVar).
	result := self applyFunction: AIFunctionAddClass withArguments: args.
	self assert: (result includesKey: 'error').
	self
		assert: (result at: 'error')
		equals: 'Invalid characters in definition. Only extended ASCII allowed.'
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testInvalidClassName [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: '123Class'.
	args at: 'superclass' put: 'Object'.
	result := self applyFunction: AIFunctionAddClass withArguments: args.
	self assert: (result includesKey: 'error').
	self
		assert: (result at: 'error')
		equals: 'Invalid class name: 123Class. Provide a valid Smalltalk class name.'
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testInvalidClassType [

	| args result |
	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample7'.
	args at: 'superclass' put: 'Object'.
	args at: 'class_type' put: 'invalid'.
	result := self applyFunction: AIFunctionAddClass withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Invalid class type invalid. Should be one of: normal, variable, variableByte, variableWord, variableLong.'
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testInvalidInstanceVariablesForType [
	| args result context types |
	types := #('variableByte' 'variableWord' 'variableLong').
	
	types do: [:type |
		args := Dictionary new.
		args at: 'class_name' put: 'AIFunctionAddClassSample7'.
		args at: 'superclass' put: 'Object'.
		args at: 'class_type' put: type.
		args at: 'instance_variables' put: #('inst1').
		context := self emptyContext.
		result := self applyFunction: AIFunctionAddClass withArguments: args inContext: context.
		
		self assert: (result includesKey: 'error').
		self assert: (result at: 'error') equals: ('Instance variables are not supported for class type %1' bindWith: type).
	].
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testInvalidSyntax [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample4'.
	args at: 'superclass' put: 'Invalid Superclass'. "invalid syntax"
	result := self applyFunction: AIFunctionAddClass withArguments: args.
	self assert: (result includesKey: 'error')
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testSubclassOfProposedClass [

	| args result context classChange |

	classChange := AIAddClassChange
		definition: 'Object subclass: #AIFunctionProposedSuperclass
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: '''' '
		application: nil.

	context := self contextWithChange: classChange.

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample9'.
	args at: 'superclass' put: 'AIFunctionProposedSuperclass'.
	
	result := self applyFunction: AIFunctionAddClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testUnknownSuperclassIsFlagged [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample8'.
	args at: 'superclass' put: 'NonExistentSuperclassWhichNobodyDefines'.
	result := self applyFunction: AIFunctionAddClass withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Unknown superclass: NonExistentSuperclassWhichNobodyDefines'.
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testValidClass [

	| args result context |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample'.
	args at: 'superclass' put: 'Object'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionAddClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	self assert: context codeChanges first changeClassName equals: #AIFunctionAddClassSample
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testValidClassWithClassInstanceVariables [

	| args result context change |
	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSampleCIV'.
	args at: 'superclass' put: 'Object'.
	args at: 'class_instance_variables' put: #('cInst1' 'cInst2').
	context := self emptyContext.
	result := self applyFunction: AIFunctionAddClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: (change definition includesSubstring: 'classInstanceVariableNames: ''cInst1 cInst2 ''').
]

{ #category : 'Tests' }
AIFunctionAddClassTest >> testValidClassWithVariables [

	| args result context change |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionAddClassSample5'.
	args at: 'superclass' put: 'Object'.
	args at: 'instance_variables' put: #('inst1' 'inst2').
	args at: 'class_instance_variables' put: #('cInst1').
	args at: 'class_variables' put: #('ClassVar1').
	args at: 'pool_dictionaries' put: #('PoolDict1').
	context := self emptyContext.
	result := self applyFunction: AIFunctionAddClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: (change definition includesSubstring: 'inst1 inst2').
	self assert: (change definition includesSubstring: 'cInst1').
	self assert: (change definition includesSubstring: 'ClassVar1').
	self assert: (change definition includesSubstring: 'PoolDict1')
]
