Class {
	#name : 'AIFunctionGetClassSubclassesTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'accessing' }
AIFunctionGetClassSubclassesTest >> testDirectSubclasses [
	| args result subclasses |
	args := Dictionary new.
	args at: 'classes' put: { 'Number' }.
	result := AIFunctionGetClassSubclasses new applyFunctionTo: args in: nil.
	
	subclasses := (result at: 'subclasses_per_class') at: 'Number'.
	self assert: subclasses size equals: 4.
	#('Float' 'Fraction' 'Integer' 'ScaledDecimal') do: [ :each |
		self assert: (subclasses includes: each) ].
	self assert: (result at: 'nonexistent_or_outside_scope_classes') isEmpty.
]

{ #category : 'accessing' }
AIFunctionGetClassSubclassesTest >> testIndirectSubclasses [
	| args result dict subclasses |
	args := Dictionary new.
	args at: 'classes' put:  { 'Number' }.
	args at: 'include_indirect' put: true.
	result := AIFunctionGetClassSubclasses new applyFunctionTo: args in: nil.
	
	dict := result at: 'subclasses_per_class'.
	self assert: dict size equals: 7.
	
	subclasses := dict at: 'Number'.
	self assert: subclasses size equals: 4.
	#('Float' 'Fraction' 'Integer' 'ScaledDecimal') do: [ :each |
		self assert: (subclasses includes: each) ].
		
	subclasses := dict at: 'Integer'.
	self assert: subclasses size equals: 2.
	#('LargeInteger' 'SmallInteger') do: [ :each |
		self assert: (subclasses includes: each) ].
		
	subclasses := dict at: 'SmallInteger'.
	self assert: subclasses isEmpty.
	
	self assert: (result at: 'nonexistent_or_outside_scope_classes') isEmpty.
]

{ #category : 'accessing' }
AIFunctionGetClassSubclassesTest >> testNonexistentClass [
	| args result |
	args := Dictionary new.
	args at: 'classes' put: { 'NonexistentClassThatShouldNotBeFound' }.
	result := AIFunctionGetClassSubclasses new applyFunctionTo: args in: nil.
	
	self assert: (result at: 'subclasses_per_class') isEmpty.
	self assert: (result at: 'nonexistent_or_outside_scope_classes') asArray equals: #('NonexistentClassThatShouldNotBeFound').
]

{ #category : 'accessing' }
AIFunctionGetClassSubclassesTest >> testNonexistentClassIndirect [
	| args result |
	args := Dictionary new.
	args at: 'classes' put: { 'NonexistentClassThatShouldNotBeFound' }.
	args at: 'include_indirect' put: true.
	result := AIFunctionGetClassSubclasses new applyFunctionTo: args in: nil.
	
	self assert: (result at: 'subclasses_per_class') isEmpty.
	self assert: (result at: 'nonexistent_or_outside_scope_classes') asArray equals: #('NonexistentClassThatShouldNotBeFound').
]
