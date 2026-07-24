Class {
	#name : 'AIFunctionDescribeTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIFunctionDescribeTest >> testClass [

	self assert: (AIFunctionDescribe new applyFunctionTo: (EsOrderedDictionary with: 'entity' -> 'Unicodestring') in: nil)
		equals: (EsOrderedDictionary
			with: 'class' -> 'UnicodeString'
			with: 'super' -> 'AdditiveSequenceableCollection'
			with: 'pool_dictionaries' -> #(CldtConstants UnicodeComponentIds UnicodeNormalization UnicodeEndian UnicodeEscape)
			with: 'application' -> 'UnicodeSupport').

	self assert: (AIFunctionDescribe new applyFunctionTo: (EsOrderedDictionary with: 'entity' -> 'Object') in: nil)
		equals: (EsOrderedDictionary
			with: 'class' -> 'Object'
			with: 'super' -> nil
			with: 'pool_dictionaries' -> #(SystemPrimitiveErrors SystemExceptions)
			with: 'application' -> 'Core').
]

{ #category : 'Not categorized' }
AIFunctionDescribeTest >> testGlobal [
	|args result|
	args := Dictionary new.
	args at: 'entity' put: 'transcript'.
	result := AIFunctionDescribe new applyFunctionTo: args in: nil. 
	self assert: (result at: 'globalVariable') equals: 'Transcript'.
	self assert: (result at: 'instanceOfClass') equals: Transcript class name asString.
]

{ #category : 'Not categorized' }
AIFunctionDescribeTest >> testPool [
	|args result definingMethod|
	args := Dictionary new.
	args at: 'entity' put: 'unicodeEndian'.
	result := AIFunctionDescribe new applyFunctionTo: args in: nil. 
	self assert: (result at: 'pool') equals: 'UnicodeEndian'.
	self assert: (result at: 'definedIn') size equals: 1.
	definingMethod := (result at: 'definedIn') first.
	self assert: (definingMethod at: 'class') equals: 'UnicodeSupport class'.
	self assert: (definingMethod at: 'selector') equals: '_PRAGMA_UnicodeEndian'.

]

{ #category : 'Not categorized' }
AIFunctionDescribeTest >> testUnknown [
	|args result |
	args := Dictionary new.
	args at: 'entity' put: 'nothingToSeeWellAtLeastThereShouldntBe'.
	result := AIFunctionDescribe new applyFunctionTo: args in: nil. 
	self assert: (result at: 'error' ifAbsent: [nil]) notNil
	
]
