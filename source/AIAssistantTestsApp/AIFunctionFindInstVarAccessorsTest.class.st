Class {
	#name : 'AIFunctionFindInstVarAccessorsTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionFindInstVarAccessorsTest >> testFindInstVarAccessors [

	| args result methods selectors |

	args := Dictionary new.
	args at: 'class' put: 'AIFunctionFindInstVarAccessorsTestMockBase'.
	args at: 'instance_variable' put: 'myVar'.
	
	result := AIFunctionFindInstVarAccessors new applyFunctionTo: args in: nil. 
	
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'methods').
	self assert: result size equals: 1.
	methods := result at: 'methods'.
	self assert: methods size equals: 2.
	
	selectors := methods collect: [:each | each at: 'selector'].
	
	self assert: (selectors includes: 'baseMethod').
	self assert: (selectors includes: 'subMethod').
	self deny: (selectors includes: 'unrelatedMethod').
]

{ #category : 'Tests' }
AIFunctionFindInstVarAccessorsTest >> testFindInstVarAccessorsFromSubclass [

	| args result methods selectors |

	args := Dictionary new.
	args at: 'class' put: 'AIFunctionFindInstVarAccessorsTestMockSub'.
	args at: 'instance_variable' put: 'myVar'.
	
	result := AIFunctionFindInstVarAccessors new applyFunctionTo: args in: nil. 
	
	self deny: (result includesKey: 'error').
	self assert: (result includesKey: 'methods').
	self assert: result size equals: 1.
	methods := result at: 'methods'.
	self assert: methods size equals: 2.
	
	selectors := methods collect: [:each | each at: 'selector'].
	
	self assert: (selectors includes: 'baseMethod').
	self assert: (selectors includes: 'subMethod').
]

{ #category : 'Tests' }
AIFunctionFindInstVarAccessorsTest >> testFindInstVarAccessorsNonExistentClass [

	| args result |

	args := Dictionary new.
	args at: 'class' put: 'SomeNonExistentClass123'.
	args at: 'instance_variable' put: 'chat'.
	
	result := AIFunctionFindInstVarAccessors new applyFunctionTo: args in: nil. 
	
	self assert: (result includesKey: 'error').
	self assert: result size equals: 1.
	self assert: (result at: 'error') equals: 'Class SomeNonExistentClass123 not found'.
]

{ #category : 'Tests' }
AIFunctionFindInstVarAccessorsTest >> testFindInstVarAccessorsNonExistentVar [

	| args result |

	args := Dictionary new.
	args at: 'class' put: 'AIFunctionFindInstVarAccessorsTestMockSub'.
	args at: 'instance_variable' put: 'someNonExistentVar'.
	
	result := AIFunctionFindInstVarAccessors new applyFunctionTo: args in: nil. 
	
	self assert: (result includesKey: 'error').
	self assert: result size equals: 1.
	self assert: (result at: 'error') equals: 'Instance variable someNonExistentVar not found in class AIFunctionFindInstVarAccessorsTestMockSub'.
]
