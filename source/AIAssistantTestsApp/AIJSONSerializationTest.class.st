Class {
	#name : 'AIJSONSerializationTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIJSONSerializationTest >> testClassAIJSON [
	"Verify that Class>>#aiJSON returns the complete expected dictionary."

	self
		assert: AIJSONMockClass aiJSON
		equals: (EsOrderedDictionary
			with: 'superclass' -> 'Object'
			with: 'instance_variables' -> #('var1' 'var2')
			with: 'class_variables' -> #('AClassVar3' 'ClassVar1' 'ZClassVar2')
			with: 'pool_dictionaries' -> #('CldtConstants')
			with: 'application' -> 'AIAssistantTestsApp')
]

{ #category : 'tests' }
AIJSONSerializationTest >> testClassSideCompiledMethodAIJSON [
	"Verify that CompiledMethod>>#aiJSON on a class method returns the complete expected dictionary."

	self
		assert: (AIJSONMockClass class >> #mockClassMethod) aiJSON
		equals: (EsOrderedDictionary new
			at: 'class' put: 'AIJSONMockClass';
			at: 'side' put: 'class';
			at: 'application' put: 'AIAssistantTestsApp';
			at: 'is_private' put: false;
			at: 'categories' put: (OrderedCollection with: 'mock');
			at: 'selector' put: 'mockClassMethod';
			at: 'source' put: (CldtConstants::LineDelimiter join: { 'mockClassMethod'. (String with: Character tab) , '^ ''this is a mock class method''' });
			yourself)
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testCollectionAIJSON [
	"Verify full dictionary equality for a Collection, including size, instance_variables, and elements."

	| context coll backingArray firstIndexVal lastIndexVal json |
	context := self emptyContext.
	coll := OrderedCollection with: 'first' with: 2 with: #third.
	backingArray := coll instVarAt: 1.
	firstIndexVal := coll instVarAt: 2.
	lastIndexVal := coll instVarAt: 3.

	json := coll aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 2.

	self
		assert: json
		equals: (EsOrderedDictionary
			with: 'class' -> 'OrderedCollection'
			with: 'object_handle' -> 1
			with: 'size' -> 3
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'elements' -> (EsOrderedDictionary
					with: 'class' -> backingArray class name asString
					with: 'print_string' -> (backingArray printStringLimitedTo: 200)
					with: 'object_handle' -> 2)
				with: 'firstIndex' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> firstIndexVal printString
					with: 'object_handle' -> 3)
				with: 'lastIndex' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> lastIndexVal printString
					with: 'object_handle' -> 4))
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''first'''
					with: 'object_handle' -> 5)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '2'
					with: 'object_handle' -> 6)))
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testCompiledMethodAIJSON [
	"Verify that CompiledMethod>>#aiJSON on an instance method returns the complete expected dictionary."

	self
		assert: (AIJSONMockClass >> #mockMethod) aiJSON
		equals: (EsOrderedDictionary new
			at: 'class' put: 'AIJSONMockClass';
			at: 'side' put: 'instance';
			at: 'application' put: 'AIAssistantTestsApp';
			at: 'is_private' put: false;
			at: 'categories' put: (OrderedCollection with: 'mock');
			at: 'selector' put: 'mockMethod';
			at: 'source' put: (CldtConstants::LineDelimiter join: { 'mockMethod'. (String with: Character tab) , '^ ''this is a mock method''' });
			yourself)
]

{ #category : 'tests' }
AIJSONSerializationTest >> testExtensionMethodAIJSON [
	"Verify that CompiledMethod>>#aiJSON on an extension method reports the extending application."

	| method |

	method := CompiledMethod >> #aiJSON.
	self
		assert: method aiJSON
		equals: (EsOrderedDictionary new
			at: 'class' put: 'CompiledMethod';
			at: 'side' put: 'instance';
			at: 'application' put: 'AIAssistantFunctionsApp';
			at: 'is_private' put: false;
			at: 'categories' put: (OrderedCollection with: 'AIAssistant');
			at: 'selector' put: 'aiJSON';
			at: 'source' put: method sourceString;
			yourself)
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testKeyedCollectionKeyCollisionsAndUnprintableKeysAIJSON [
	"Verify full dictionary equality for a KeyedCollection with colliding key printStrings and unprintable keys."

	| context dict key1 key2 unprintable1 unprintable2 seqKeys seqVals lookupTable truncKey json |
	context := self emptyContext.
	dict := EsOrderedDictionary new.
	key1 := 'collision_one'.
	key2 := 'collision_two'.
	unprintable1 := AIJSONMockUnprintableObject new.
	unprintable2 := AIJSONMockUnprintableObject new.
	dict
		at: key1 put: 10;
		at: key2 put: 20;
		at: unprintable1 put: 30;
		at: unprintable2 put: 40.

	seqKeys := dict instVarAt: 1.
	seqVals := dict instVarAt: 2.
	lookupTable := dict instVarAt: 3.
	truncKey := key1 printStringLimitedTo: 10.

	json := dict aiJSONInContext: context stringsLimitedTo: 10 indexedLimitedTo: 50.

	self
		assert: json
		equals: (EsOrderedDictionary
			with: 'class' -> 'EsOrderedDictionary'
			with: 'object_handle' -> 1
			with: 'size' -> 4
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'sequenceableKeys' -> (EsOrderedDictionary
					with: 'class' -> seqKeys class name asString
					with: 'print_string' -> (seqKeys printStringLimitedTo: 10)
					with: 'object_handle' -> 2)
				with: 'sequenceableValues' -> (EsOrderedDictionary
					with: 'class' -> seqVals class name asString
					with: 'print_string' -> (seqVals printStringLimitedTo: 10)
					with: 'object_handle' -> 3)
				with: 'lookupTable' -> (EsOrderedDictionary
					with: 'class' -> lookupTable class name asString
					with: 'print_string' -> (lookupTable printStringLimitedTo: 10)
					with: 'object_handle' -> 4))
			with: 'elements' -> (EsOrderedDictionary
				with: truncKey -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '10'
					with: 'object_handle' -> 5)
				with: (truncKey , ' (2)') -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '20'
					with: 'object_handle' -> 6)
				with: 'Could not print object' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '30'
					with: 'object_handle' -> 7)
				with: 'Could not print object (2)' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '40'
					with: 'object_handle' -> 8)))
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testNonPointerArrayedCollectionsAndUnicodeStringAIJSON [
	"Verify full dictionary equality for non-pointer ArrayedCollections and UnicodeString."

	| context str sym uni byteArr longArr utf8 |
	context := self emptyContext.

	str := 'hello'.
	self
		assert: (str aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 50)
		equals: (EsOrderedDictionary
			with: 'class' -> 'String'
			with: 'print_string' -> '''hello'''
			with: 'object_handle' -> 1).

	sym := #mySymbol.
	self
		assert: (sym aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 50)
		equals: (EsOrderedDictionary
			with: 'class' -> 'Symbol'
			with: 'print_string' -> '#mySymbol'
			with: 'object_handle' -> 2).

	uni := 'hello unicode' asUnicodeString.
	self
		assert: (uni aiJSONInContext: context stringsLimitedTo: 6 indexedLimitedTo: 50)
		equals: (EsOrderedDictionary
			with: 'class' -> 'UnicodeString'
			with: 'print_string' -> (uni printStringLimitedTo: 6)
			with: 'object_handle' -> 3).

	byteArr := #[10 20 30].
	self
		assert: (byteArr aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 50)
		equals: (EsOrderedDictionary
			with: 'class' -> 'ByteArray'
			with: 'print_string' -> '[10 20 30]'
			with: 'object_handle' -> 4).

	longArr := EsLongArray with: 100 with: 200.
	self
		assert: (longArr aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 50)
		equals: (EsOrderedDictionary
			with: 'class' -> 'EsLongArray'
			with: 'print_string' -> (longArr printStringLimitedTo: 200)
			with: 'object_handle' -> 5).

	utf8 := 'abc' asUtf8.
	self
		assert: (utf8 aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 50)
		equals: (EsOrderedDictionary
			with: 'class' -> 'Utf8'
			with: 'print_string' -> (utf8 printStringLimitedTo: 200)
			with: 'object_handle' -> 6)
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testNormalObjectAIJSON [
	"Verify full dictionary equality for a standard object with named instance variables."

	| context mock json |
	context := self emptyContext.
	mock := AIJSONMockClass new
		var1: 'hello';
		var2: 42;
		yourself.

	json := mock aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 50.

	self
		assert: json
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockClass'
			with: 'print_string' -> 'an AIJSONMockClass'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'var1' -> (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''hello'''
					with: 'object_handle' -> 2)
				with: 'var2' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '42'
					with: 'object_handle' -> 3)))
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testObjectReferenceAIJSON [
	"Verify that Object>>#aiJSONReferenceInContext:printStringLimitedTo: returns the exact reference dictionary."

	| context point json |
	context := self emptyContext.
	point := 10 @ 20.

	json := point aiJSONReferenceInContext: context printStringLimitedTo: 200.

	self
		assert: json
		equals: (EsOrderedDictionary
			with: 'class' -> 'Point'
			with: 'print_string' -> '10 @ 20'
			with: 'object_handle' -> 1).
	self assert: (context objectRegistry objectFor: 1 ifAbsent: [ nil ]) == point
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testPointerVariableObjectAIJSON [
	"Verify full dictionary equality for a non-Collection pointer variable class with named and indexed slots."

	| context varObj json |
	context := self emptyContext.
	varObj := (AIJSONMockVariableClass new: 3)
		namedVar: 'named';
		basicAt: 1 put: 100;
		basicAt: 2 put: 'second';
		basicAt: 3 put: #third;
		yourself.

	json := varObj aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 2.

	self
		assert: json
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockVariableClass'
			with: 'print_string' -> 'an AIJSONMockVariableClass'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'namedVar' -> (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''named'''
					with: 'object_handle' -> 2))
			with: 'size' -> 3
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '100'
					with: 'object_handle' -> 3)
				with: (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''second'''
					with: 'object_handle' -> 4)))
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testSelfReferencingCollectionsAIJSON [
	"Verify full dictionary equality for collections and dictionaries containing themselves."

	| context array dict seqKeys seqVals lookupTable |
	context := self emptyContext.

	array := Array new: 1.
	array at: 1 put: array.
	self
		assert: (array aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 10)
		equals: (EsOrderedDictionary
			with: 'class' -> 'Array'
			with: 'object_handle' -> 1
			with: 'size' -> 1
			with: 'instance_variables' -> EsOrderedDictionary new
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'Array'
					with: 'print_string' -> (array printStringLimitedTo: 200)
					with: 'object_handle' -> 1))).

	dict := EsOrderedDictionary new.
	dict at: 'self' put: dict.
	seqKeys := dict instVarAt: 1.
	seqVals := dict instVarAt: 2.
	lookupTable := dict instVarAt: 3.
	self
		assert: (dict aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 10)
		equals: (EsOrderedDictionary
			with: 'class' -> 'EsOrderedDictionary'
			with: 'object_handle' -> 2
			with: 'size' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'sequenceableKeys' -> (EsOrderedDictionary
					with: 'class' -> seqKeys class name asString
					with: 'print_string' -> (seqKeys printStringLimitedTo: 200)
					with: 'object_handle' -> 3)
				with: 'sequenceableValues' -> (EsOrderedDictionary
					with: 'class' -> seqVals class name asString
					with: 'print_string' -> (seqVals printStringLimitedTo: 200)
					with: 'object_handle' -> 4)
				with: 'lookupTable' -> (EsOrderedDictionary
					with: 'class' -> lookupTable class name asString
					with: 'print_string' -> (lookupTable printStringLimitedTo: 200)
					with: 'object_handle' -> 5))
			with: 'elements' -> (EsOrderedDictionary
				with: '''self''' -> (EsOrderedDictionary
					with: 'class' -> 'EsOrderedDictionary'
					with: 'print_string' -> (dict printStringLimitedTo: 200)
					with: 'object_handle' -> 2)))
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testStackFrameAIJSON [
	"Verify full dictionary equality for EsStackFrame>>#aiJSONInContext:stringsLimitedTo:indexedLimitedTo:."

	| context process frame json |
	context := self emptyContext.
	process := [
		[ :blockArg |
			| blockTemp |
			blockTemp := blockArg , ' world'.
			Processor activeProcess suspend.
			blockTemp ] value: 'hello' ] fork.
	[ process isSuspended ] whileFalse: [ (Delay forMilliseconds: 10) wait ].

	[
		frame := process allFrames
			detect: [ :f | f printString includesSubstring: 'testStackFrameAIJSON' ]
			ifNone: [ self fail: 'Expected frame for testStackFrameAIJSON' ].
		json := frame aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 50.

		self
			assert: json
			equals: (EsOrderedDictionary
				with: 'signature' -> frame printString
				with: 'receiver' -> (EsOrderedDictionary
					with: 'class' -> frame receiver class name asString
					with: 'print_string' -> (frame receiver printStringLimitedTo: 200)
					with: 'object_handle' -> (context objectRegistry register: frame receiver))
				with: 'arguments' -> (EsOrderedDictionary
					with: 'blockArg' -> (EsOrderedDictionary
						with: 'class' -> 'String'
						with: 'print_string' -> '''hello'''
						with: 'object_handle' -> 1))
				with: 'temporaries' -> (EsOrderedDictionary
					with: 'blockTemp' -> (EsOrderedDictionary
						with: 'class' -> 'String'
						with: 'print_string' -> '''hello world'''
						with: 'object_handle' -> 2))).
		self assert: (context objectRegistry objectFor: 1 ifAbsent: [ nil ]) equals: 'hello'.
		self assert: (context objectRegistry objectFor: 2 ifAbsent: [ nil ]) equals: 'hello world'
	] ensure: [ process terminate ]
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testUninitializedAndNegativeLimitCollectionsAIJSON [
	"Verify full dictionary equality when serializing collections with negative indexedLimit
	 and uninitialized collections created via basicNew."

	| context nilRef uninitColl uninitDict |
	context := self emptyContext.
	nilRef := EsOrderedDictionary
		with: 'class' -> 'UndefinedObject'
		with: 'print_string' -> 'nil'
		with: 'object_handle' -> 0.

	uninitColl := OrderedCollection basicNew.
	self
		assert: (uninitColl aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 10)
		equals: (EsOrderedDictionary
			with: 'class' -> 'OrderedCollection'
			with: 'object_handle' -> 1
			with: 'size' -> nil
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'elements' -> nilRef
				with: 'firstIndex' -> nilRef
				with: 'lastIndex' -> nilRef)
			with: 'elements' -> OrderedCollection new).

	uninitDict := Dictionary basicNew.
	self
		assert: (uninitDict aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: 10)
		equals: (EsOrderedDictionary
			with: 'class' -> 'Dictionary'
			with: 'object_handle' -> 2
			with: 'size' -> nil
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'elementCount' -> nilRef
				with: 'elements' -> nilRef)
			with: 'elements' -> EsOrderedDictionary new).

	self
		assert: (#(1 2) aiJSONInContext: context stringsLimitedTo: 200 indexedLimitedTo: -5)
		equals: (EsOrderedDictionary
			with: 'class' -> 'Array'
			with: 'object_handle' -> 3
			with: 'size' -> 2
			with: 'instance_variables' -> EsOrderedDictionary new
			with: 'elements' -> OrderedCollection new)
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testUnprintableObjectReferenceAIJSON [
	"Verify that an object whose printOn: fails still produces a valid reference dictionary."

	| context unprintable json |
	context := self emptyContext.
	unprintable := AIJSONMockUnprintableObject new.

	json := unprintable aiJSONReferenceInContext: context printStringLimitedTo: 200.

	self
		assert: json
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockUnprintableObject'
			with: 'print_string' -> 'Could not print object'
			with: 'object_handle' -> 1).
	self assert: (context objectRegistry objectFor: 1 ifAbsent: [ nil ]) == unprintable
]
