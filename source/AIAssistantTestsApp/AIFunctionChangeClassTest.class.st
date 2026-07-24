Class {
	#name : 'AIFunctionChangeClassTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testApplicationNotFound [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'TestCase'.
	args at: 'application' put: 'NonExistentApp123'.
	result := self applyFunction: AIFunctionChangeClass withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Application NonExistentApp123 not found'
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testChangeClassType [
	| args result context change types |
	types := Dictionary new.
	types at: 'variable' put: 'variableSubclass:'.
	types at: 'variableByte' put: 'variableByteSubclass:'.
	types at: 'variableWord' put: 'variableWordSubclass:'.
	types at: 'variableLong' put: 'variableLongSubclass:'.
	
	types keysAndValuesDo: [:type :keyword |
		args := Dictionary new.
		args at: 'class_name' put: 'AIFunctionChangeClassTest'.
		args at: 'superclass' put: 'TestCase'.
		args at: 'class_type' put: type.
		context := self emptyContext.
		result := self applyFunction: AIFunctionChangeClass withArguments: args inContext: context.
		
		self deny: (result includesKey: 'error').
		change := context codeChanges first.
		self assert: (change definition includesSubstring: keyword).
		(#('variableByte' 'variableWord' 'variableLong') includes: type)
			ifTrue: [ self deny: (change definition includesSubstring: 'instanceVariableNames:') ]
			ifFalse: [ self assert: (change definition includesSubstring: 'instanceVariableNames:') ].
	].
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testInvalidCharacters [

	| args result invalidVar |

	invalidVar := UnicodeString escaped: 'invalid\u{100}var'.
	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'TestCase'.
	args at: 'instance_variables' put: (Array with: invalidVar).
	result := self applyFunction: AIFunctionChangeClass withArguments: args.
	self assert: (result includesKey: 'error').
	self
		assert: (result at: 'error')
		equals: 'Invalid characters in definition. Only extended ASCII allowed.'
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testInvalidInstanceVariablesForType [
	| args result types |
	types := #('variableByte' 'variableWord' 'variableLong').
	
	types do: [:type |
		args := Dictionary new.
		args at: 'class_name' put: 'AIFunctionChangeClassTest'.
		args at: 'superclass' put: 'TestCase'.
		args at: 'class_type' put: type.
		args at: 'instance_variables' put: #('inst1').
		result := self applyFunction: AIFunctionChangeClass withArguments: args.
		
		self assert: (result includesKey: 'error').
		self assert: (result at: 'error') equals: ('Instance variables are not supported for class type %1' bindWith: type).
	].
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testInvalidSyntax [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'Invalid Superclass'.
	result := self applyFunction: AIFunctionChangeClass withArguments: args.
	self assert: (result includesKey: 'error')
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testNonExistentClass [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionNonExistentClassSample'.
	args at: 'superclass' put: 'Object'.
	result := self applyFunction: AIFunctionChangeClass withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Class AIFunctionNonExistentClassSample not found'
]

{ #category : 'accessing' }
AIFunctionChangeClassTest >> testSubclassOfProposedClass [

	| args result context classChange |

	classChange := AIAddClassChange
		definition: 'Object subclass: #AIFunctionProposedSuperclass
			instanceVariableNames: ''''
			classVariableNames: ''''
			poolDictionaries: '''' '
		application: nil.

	context := self contextWithChange: classChange.

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'AIFunctionProposedSuperclass'.
	
	result := self applyFunction: AIFunctionChangeClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testUnknownSuperclassIsFlagged [

	| args result |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'NonExistentSuperclassWhichNobodyDefines'.
	result := self applyFunction: AIFunctionChangeClass withArguments: args.
	self assert: (result includesKey: 'error').
	self assert: (result at: 'error') equals: 'Unknown superclass: NonExistentSuperclassWhichNobodyDefines'.
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testValidClass [

	| args result context change |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'TestCase'.
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'result').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: change changeClassName equals: #AIFunctionChangeClassTest
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testValidClassWithClassInstanceVariables [

	| args result context change |
	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'TestCase'.
	args at: 'class_instance_variables' put: #('cInst1' 'cInst2').
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: (change definition includesSubstring: 'classInstanceVariableNames: ''cInst1 cInst2 ''').
]

{ #category : 'Tests' }
AIFunctionChangeClassTest >> testValidClassWithVariables [

	| args result context change |

	args := Dictionary new.
	args at: 'class_name' put: 'AIFunctionChangeClassTest'.
	args at: 'superclass' put: 'TestCase'.
	args at: 'instance_variables' put: #('inst1' 'inst2').
	args at: 'class_instance_variables' put: #('cInst1').
	args at: 'class_variables' put: #('ClassVar1').
	args at: 'pool_dictionaries' put: #('PoolDict1').
	context := self emptyContext.
	result := self applyFunction: AIFunctionChangeClass withArguments: args inContext: context.
	self deny: (result includesKey: 'error').
	self assert: context codeChanges size equals: 1.
	change := context codeChanges first.
	self assert: (change definition includesSubstring: 'inst1 inst2').
	self assert: (change definition includesSubstring: 'cInst1').
	self assert: (change definition includesSubstring: 'ClassVar1').
	self assert: (change definition includesSubstring: 'PoolDict1')
]
