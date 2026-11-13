Class {
	#name : 'AIFunctionInspectObjectTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectByteObjectDoesNotIncludeIndexedSlots [

	| context string byteArray handle args result |
	context := self emptyContext.
	string := 'hello world'.
	handle := context objectRegistry register: string.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'String'
			with: 'print_string' -> '''hello world'''
			with: 'object_handle' -> 1).

	byteArray := #[1 2 3 4].
	handle := context objectRegistry register: byteArray.
	args at: 'object_handle' put: handle.

	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'ByteArray'
			with: 'print_string' -> '[1 2 3 4]'
			with: 'object_handle' -> 2)
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectClassWithClassVariables [

	| context handle args result expectedInstVars nilRef dependents |
	context := self emptyContext.
	handle := context objectRegistry register: AIJSONMockClass.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	expectedInstVars := EsOrderedDictionary new.
	AIJSONMockClass class allInstVarNames keysAndValuesDo: [ :index :varName |
		| val |
		val := AIJSONMockClass instVarAt: index.
		expectedInstVars
			at: varName
			put: (EsOrderedDictionary
				with: 'class' -> val class name asString
				with: 'print_string' -> (val printStringLimitedTo: 200)
				with: 'object_handle' -> (context objectRegistry register: val)) ].

	nilRef := EsOrderedDictionary
		with: 'class' -> 'UndefinedObject'
		with: 'print_string' -> 'nil'
		with: 'object_handle' -> 0.
	dependents := (Object classVariableAssociationFor: 'Dependents') value.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockClass class'
			with: 'print_string' -> 'AIJSONMockClass'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> expectedInstVars
			with: 'class_variables' -> (EsOrderedDictionary
				with: 'AClassVar3' -> nilRef
				with: 'ClassVar1' -> nilRef
				with: 'Dependents' -> (EsOrderedDictionary
					with: 'class' -> dependents class name asString
					with: 'print_string' -> (dependents printStringLimitedTo: 200)
					with: 'object_handle' -> (context objectRegistry register: dependents))
				with: 'ZClassVar2' -> nilRef)).

	(result at: 'class_variables') keys do: [ :key |
		self assert: key isString.
		self deny: key isSymbol ]
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectGarbageCollectedObject [

	| context handle args result |
	context := self emptyContext.
	handle := [
		| shortLivedObject |
		shortLivedObject := Object new.
		context objectRegistry register: shortLivedObject
	] value.

	System globalGarbageCollect.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> ('No object found with handle: ' , handle asString))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectKeyedCollection [

	| context dict handle seqKeys seqVals lookupTable args result |
	context := self emptyContext.
	dict := EsOrderedDictionary with: 'first' -> 42 with: #second -> 'hello'.
	handle := context objectRegistry register: dict.
	seqKeys := dict instVarAt: 1.
	seqVals := dict instVarAt: 2.
	lookupTable := dict instVarAt: 3.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'EsOrderedDictionary'
			with: 'object_handle' -> 1
			with: 'size' -> 2
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'sequenceableKeys' -> (EsOrderedDictionary
					with: 'class' -> seqKeys class name asString
					with: 'print_string' -> (seqKeys printStringLimitedTo: 200)
					with: 'object_handle' -> 2)
				with: 'sequenceableValues' -> (EsOrderedDictionary
					with: 'class' -> seqVals class name asString
					with: 'print_string' -> (seqVals printStringLimitedTo: 200)
					with: 'object_handle' -> 3)
				with: 'lookupTable' -> (EsOrderedDictionary
					with: 'class' -> lookupTable class name asString
					with: 'print_string' -> (lookupTable printStringLimitedTo: 200)
					with: 'object_handle' -> 4))
			with: 'elements' -> (EsOrderedDictionary
				with: '''first''' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '42'
					with: 'object_handle' -> 5)
				with: '#second' -> (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''hello'''
					with: 'object_handle' -> 6))).
	self assert: (context objectRegistry objectFor: 5 ifAbsent: [ nil ]) equals: 42.
	self assert: (context objectRegistry objectFor: 6 ifAbsent: [ nil ]) equals: 'hello'
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectMetaclassIncludesClassVariables [
	"Verify that inspecting a Metaclass reports its class as Metaclass, its print_string
	 as the metaclass name, and includes the class variables of its instance class."

	| context handle args result expectedInstVars nilRef classVarValue dependents |

	context := self emptyContext.
	handle := context objectRegistry register: AIJSONMockClass class.
	classVarValue := 'classVarValue'.
	AIJSONMockClass classPool at: 'ClassVar1' put: classVarValue.

	[
		args := EsOrderedDictionary with: 'object_handle' -> handle.
		result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

		expectedInstVars := EsOrderedDictionary new.
		AIJSONMockClass class class allInstVarNames keysAndValuesDo: [ :index :varName |
			| val |
			val := AIJSONMockClass class instVarAt: index.
			expectedInstVars
				at: varName
				put: (EsOrderedDictionary
					with: 'class' -> val class name asString
					with: 'print_string' -> (val printStringLimitedTo: 200)
					with: 'object_handle' -> (context objectRegistry register: val)) ].

		nilRef := EsOrderedDictionary
			with: 'class' -> 'UndefinedObject'
			with: 'print_string' -> 'nil'
			with: 'object_handle' -> 0.
		dependents := Object classPool at: 'Dependents'.

		self
			assert: result
			equals: (EsOrderedDictionary
				with: 'class' -> 'Metaclass'
				with: 'print_string' -> 'AIJSONMockClass class'
				with: 'object_handle' -> 1
				with: 'instance_variables' -> expectedInstVars
				with: 'class_variables' -> (EsOrderedDictionary
					with: 'AClassVar3' -> nilRef
					with: 'ClassVar1' -> (EsOrderedDictionary
						with: 'class' -> 'String'
						with: 'print_string' -> '''classVarValue'''
						with: 'object_handle' -> (context objectRegistry register: classVarValue))
					with: 'Dependents' -> (EsOrderedDictionary
						with: 'class' -> dependents class name asString
						with: 'print_string' -> (dependents printStringLimitedTo: 200)
						with: 'object_handle' -> (context objectRegistry register: dependents))
					with: 'ZClassVar2' -> nilRef))
	] ensure: [
		AIJSONMockClass classPool at: 'ClassVar1' put: nil ]
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectNil [

	| context handle args result |
	context := self emptyContext.
	handle := context objectRegistry register: nil.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'UndefinedObject'
			with: 'print_string' -> 'nil'
			with: 'object_handle' -> 0
			with: 'instance_variables' -> EsOrderedDictionary new)
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectNormalObject [

	| context point handle args result |
	context := self emptyContext.
	point := Point x: 10 y: 20.
	handle := context objectRegistry register: point.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'Point'
			with: 'print_string' -> '10 @ 20'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'x' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '10'
					with: 'object_handle' -> 2)
				with: 'y' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '20'
					with: 'object_handle' -> 3)))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectObjectFromDebugTestCase [

	| context debugArgs debugResult stackTrace frame receiver objectHandle inspectArgs inspectResult |
	context := self emptyContext.
	debugArgs := EsOrderedDictionary
		with: 'class_name' -> 'AIFunctionDebugTestCaseMockTest'
		with: 'selector' -> 'testErrors'.

	debugResult := self applyFunction: AIFunctionDebugTestCase withArguments: debugArgs inContext: context.

	stackTrace := debugResult at: 'stack_trace'.
	self assert: stackTrace notEmpty.

	frame := stackTrace
		detect: [ :each | (each at: 'signature') includesSubstring: 'testErrors' ]
		ifNone: [ stackTrace first ].
	receiver := frame at: 'receiver'.
	objectHandle := receiver at: 'object_handle'.

	inspectArgs := EsOrderedDictionary with: 'object_handle' -> objectHandle.
	inspectResult := self applyFunction: AIFunctionInspectObject withArguments: inspectArgs inContext: context.

	self
		assert: inspectResult
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIFunctionDebugTestCaseMockTest'
			with: 'print_string' -> 'AIFunctionDebugTestCaseMockTest>>#testErrors'
			with: 'object_handle' -> objectHandle
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'testSelector' -> (EsOrderedDictionary
					with: 'class' -> 'Symbol'
					with: 'print_string' -> '#testErrors'
					with: 'object_handle' -> (context objectRegistry register: #testErrors))))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectObjectFromGetSuspendedProcess [

	| context originalDebugger mockDebugger mockSession process result stackTrace frame receiver objectHandle inspectArgs inspectResult nilRef ready debuggerRef |
	context := self emptyContext.
	originalDebugger := Processor debugger.
	mockDebugger := AIFunctionGetSuspendedProcessTestMockDebugger new.
	mockSession := AIFunctionGetSuspendedProcessTestMockSession new.
	process := [ Processor activeProcess suspend ] fork.
	[ process isSuspended ] whileFalse: [ (Delay forMilliseconds: 10) wait ].
	mockSession process: process.
	mockDebugger selectedSessions add: mockSession.

	[
		Processor debugger: mockDebugger.
		result := self applyFunction: AIFunctionGetSuspendedProcess withArguments: EsOrderedDictionary new inContext: context.
	] ensure: [
		Processor debugger: originalDebugger.
		process terminate.
	].

	stackTrace := result at: 'stack_trace'.
	self assert: stackTrace notEmpty.

	frame := stackTrace first.
	receiver := frame at: 'receiver'.
	objectHandle := receiver at: 'object_handle'.

	inspectArgs := EsOrderedDictionary with: 'object_handle' -> objectHandle.
	inspectResult := self applyFunction: AIFunctionInspectObject withArguments: inspectArgs inContext: context.

	nilRef := EsOrderedDictionary
		with: 'class' -> 'UndefinedObject'
		with: 'print_string' -> 'nil'
		with: 'object_handle' -> 0.
	ready := Processor instVarAt: 2.
	debuggerRef := originalDebugger
		ifNil: [ nilRef ]
		ifNotNil: [
			EsOrderedDictionary
				with: 'class' -> originalDebugger class name asString
				with: 'print_string' -> (originalDebugger printStringLimitedTo: 200)
				with: 'object_handle' -> (context objectRegistry register: originalDebugger) ].

	self
		assert: inspectResult
		equals: (EsOrderedDictionary
			with: 'class' -> 'ProcessorScheduler'
			with: 'print_string' -> 'a ProcessorScheduler'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'obsolete' -> nilRef
				with: 'ready' -> (EsOrderedDictionary
					with: 'class' -> 'Array'
					with: 'print_string' -> (ready printStringLimitedTo: 200)
					with: 'object_handle' -> (context objectRegistry register: ready))
				with: 'lockedProcess' -> nilRef
				with: 'obsolete2' -> nilRef
				with: 'debugger' -> debuggerRef))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectObjectNegativeLimits [

	| context array handle args result |
	context := self emptyContext.
	array := Array with: 1 with: 2 with: 3.
	handle := context objectRegistry register: array.

	args := EsOrderedDictionary
		with: 'object_handle' -> handle
		with: 'printstring_limit' -> -10
		with: 'indexed_limit' -> -5.

	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'Array'
			with: 'object_handle' -> 1
			with: 'size' -> 3
			with: 'instance_variables' -> EsOrderedDictionary new
			with: 'elements' -> OrderedCollection new)
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectObjectNotFound [
	| args result |
	args := EsOrderedDictionary with: 'object_handle' -> 999999.

	result := self applyFunction: AIFunctionInspectObject withArguments: args.

	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> 'No object found with handle: 999999')
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectObjectPrintStringLimit [

	| context string handle args result |
	context := self emptyContext.
	string := String new: 500 withAll: $z.
	handle := context objectRegistry register: string.

	args := EsOrderedDictionary
		with: 'object_handle' -> handle
		with: 'printstring_limit' -> 15.

	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'String'
			with: 'print_string' -> (string printStringLimitedTo: 15)
			with: 'object_handle' -> 1)
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectObjectPrintStringLimitPropagatesToChildren [

	| context mock longString handle args result |
	context := self emptyContext.
	longString := String new: 100 withAll: $m.
	mock := AIJSONMockClass new
		var1: longString;
		yourself.
	handle := context objectRegistry register: mock.

	args := EsOrderedDictionary
		with: 'object_handle' -> handle
		with: 'printstring_limit' -> 12.

	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockClass'
			with: 'print_string' -> (mock printStringLimitedTo: 12)
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'var1' -> (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> (longString printStringLimitedTo: 12)
					with: 'object_handle' -> 2)
				with: 'var2' -> (EsOrderedDictionary
					with: 'class' -> 'UndefinedObject'
					with: 'print_string' -> 'nil'
					with: 'object_handle' -> 0)))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectPointerVariableNonCollectionObject [

	| context varObj handle args result |
	context := self emptyContext.
	varObj := (AIJSONMockVariableClass new: 3)
		namedVar: 'namedValue';
		basicAt: 1 put: 10;
		basicAt: 2 put: 20;
		basicAt: 3 put: 30;
		yourself.
	handle := context objectRegistry register: varObj.

	args := EsOrderedDictionary
		with: 'object_handle' -> handle
		with: 'indexed_limit' -> 2.

	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockVariableClass'
			with: 'print_string' -> 'an AIJSONMockVariableClass'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'namedVar' -> (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''namedValue'''
					with: 'object_handle' -> 2))
			with: 'size' -> 3
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '10'
					with: 'object_handle' -> 3)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '20'
					with: 'object_handle' -> 4)))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectSelfReferencingObject [
	"Verify that inspecting an object with a cyclic self-reference terminates
	 and assigns the same object_handle to the child reference."

	| context mock handle args result |
	context := self emptyContext.
	mock := AIJSONMockClass new.
	mock var1: mock.
	handle := context objectRegistry register: mock.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockClass'
			with: 'print_string' -> 'an AIJSONMockClass'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'var1' -> (EsOrderedDictionary
					with: 'class' -> 'AIJSONMockClass'
					with: 'print_string' -> 'an AIJSONMockClass'
					with: 'object_handle' -> 1)
				with: 'var2' -> (EsOrderedDictionary
					with: 'class' -> 'UndefinedObject'
					with: 'print_string' -> 'nil'
					with: 'object_handle' -> 0)))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectUnprintableObjectIncludesInstanceVariables [
	"Verify that an object whose printOn: signals an error still serializes its instance variables."

	| context unprintable handle args result |
	context := self emptyContext.
	unprintable := AIJSONMockUnprintableObject new
		id: 42;
		yourself.
	handle := context objectRegistry register: unprintable.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'AIJSONMockUnprintableObject'
			with: 'print_string' -> 'Could not print object'
			with: 'object_handle' -> 1
			with: 'instance_variables' -> (EsOrderedDictionary
				with: 'id' -> (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '42'
					with: 'object_handle' -> 2)))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectVariableObject [

	| context array handle args result |
	context := self emptyContext.
	array := Array with: 42 with: 'hello'.
	handle := context objectRegistry register: array.

	args := EsOrderedDictionary with: 'object_handle' -> handle.
	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'Array'
			with: 'object_handle' -> 1
			with: 'size' -> 2
			with: 'instance_variables' -> EsOrderedDictionary new
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '42'
					with: 'object_handle' -> 2)
				with: (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''hello'''
					with: 'object_handle' -> 3)))
]

{ #category : 'Tests' }
AIFunctionInspectObjectTest >> testInspectVariableObjectIndexedLimit [

	| context array handle args result |
	context := self emptyContext.
	array := (1 to: 10) asArray.
	handle := context objectRegistry register: array.

	args := EsOrderedDictionary
		with: 'object_handle' -> handle
		with: 'indexed_limit' -> 3.

	result := self applyFunction: AIFunctionInspectObject withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'class' -> 'Array'
			with: 'object_handle' -> 1
			with: 'size' -> 10
			with: 'instance_variables' -> EsOrderedDictionary new
			with: 'elements' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '1'
					with: 'object_handle' -> 2)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '2'
					with: 'object_handle' -> 3)
				with: (EsOrderedDictionary
					with: 'class' -> 'SmallInteger'
					with: 'print_string' -> '3'
					with: 'object_handle' -> 4)))
]
