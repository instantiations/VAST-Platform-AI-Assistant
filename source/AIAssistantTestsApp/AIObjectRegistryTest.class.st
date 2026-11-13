Class {
	#name : 'AIObjectRegistryTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIObjectRegistryTest >> testGarbageCollectedObjectIsRemoved [
	| registry handle objectsByHandle handlesByObject absent object |
	registry := AIObjectRegistry new.
	object := Object new.
	handle := registry register: object.

	objectsByHandle := registry instVarNamed: 'objectsByHandle'.
	handlesByObject := registry instVarNamed: 'handlesByObject'.

	self deny: objectsByHandle isEmpty.
	self deny: handlesByObject isEmpty.

	System globalGarbageCollect.
	[ Processor finalizeCycle ] whileTrue: [].

	self deny: objectsByHandle isEmpty.
	self deny: handlesByObject isEmpty.

	object := nil.

	System globalGarbageCollect.
	[ Processor finalizeCycle ] whileTrue: [].

	self assert: objectsByHandle isEmpty.
	self assert: handlesByObject isEmpty.

	absent := false.
	registry objectFor: handle ifAbsent: [ absent := true ].
	self assert: absent.
]

{ #category : 'Tests' }
AIObjectRegistryTest >> testGarbageCollectedObjectsLeaveLiveObjectsIntact [
	| registry liveObject liveHandle deadHandle1 deadHandle2 objectsByHandle handlesByObject |
	registry := AIObjectRegistry new.
	liveObject := Object new.

	deadHandle1 := [ registry register: Object new ] value.
	liveHandle := registry register: liveObject.
	deadHandle2 := [ registry register: Object new ] value.

	objectsByHandle := registry instVarNamed: 'objectsByHandle'.
	handlesByObject := registry instVarNamed: 'handlesByObject'.

	self assert: objectsByHandle size equals: 3.
	self assert: handlesByObject size equals: 3.

	System globalGarbageCollect.
	[ Processor finalizeCycle ] whileTrue: [].

	self assert: objectsByHandle size equals: 1.
	self assert: handlesByObject size equals: 1.

	self assert: (registry objectFor: liveHandle ifAbsent: [ self fail ]) == liveObject.
	self assert: (registry register: liveObject) equals: liveHandle.
	self assert: (registry objectFor: deadHandle1 ifAbsent: [ #absent ]) equals: #absent.
	self assert: (registry objectFor: deadHandle2 ifAbsent: [ #absent ]) equals: #absent.
]

{ #category : 'Tests' }
AIObjectRegistryTest >> testRegisterAndLookup [
	| registry obj1 obj2 handle1 handle2 |
	registry := AIObjectRegistry new.
	obj1 := Object new.
	obj2 := Object new.

	handle1 := registry register: obj1.
	handle2 := registry register: obj2.

	self deny: handle1 = handle2.
	self assert: (registry register: obj1) equals: handle1.
	self assert: (registry objectFor: handle1 ifAbsent: [ self fail ]) == obj1.
	self assert: (registry objectFor: handle2 ifAbsent: [ self fail ]) == obj2.
]

{ #category : 'Tests' }
AIObjectRegistryTest >> testRegisterNil [
	| registry nilHandle |
	registry := AIObjectRegistry new.
	nilHandle := registry register: nil.

	self assert: (registry register: nil) equals: nilHandle.
	self assert: (registry objectFor: nilHandle ifAbsent: [ #absent ]) isNil.
]

{ #category : 'Tests' }
AIObjectRegistryTest >> testReopenedChatPreservesNextObjectHandleCounter [
	"Verify that saving and reopening an AIChat preserves the objectRegistry nextHandle counter,
	 and that opening a legacy saved chat without nextObjectHandle: still works and starts at 1."

	| chat handle1 handle2 storedString reopenedChat newObject newHandle |
	chat := AIChat
		systemInstruction: 'Test instruction'
		model: AIChatTest testModels first
		filePaths: OrderedCollection new
		userMessages: OrderedCollection new.

	handle1 := chat objectRegistry register: Object new.
	handle2 := chat objectRegistry register: Object new.
	self assert: handle1 equals: 1.
	self assert: handle2 equals: 2.
	self assert: chat objectRegistry nextHandle equals: 3.

	storedString := String streamContents: [ :stream | chat storeOn: stream ].
	reopenedChat := Compiler evaluate: storedString.

	self assert: reopenedChat objectRegistry nextHandle equals: 3.
	newObject := Object new.
	newHandle := reopenedChat objectRegistry register: newObject.
	self assert: newHandle equals: 3.
	self assert: (reopenedChat objectRegistry objectFor: 1 ifAbsent: [ #absent ]) equals: #absent.
	self assert: (reopenedChat objectRegistry objectFor: 2 ifAbsent: [ #absent ]) equals: #absent.
	self assert: (reopenedChat objectRegistry objectFor: 3 ifAbsent: [ #absent ]) == newObject
]

{ #category : 'Tests' }
AIObjectRegistryTest >> testRetainLimitsToMaxRetainedObjects [
	"Verify that retain: keeps at most 10 objects strongly referenced, evicting the oldest
	 objects so they can be reclaimed by garbage collection."

	| registry handles |
	registry := AIObjectRegistry new.
	handles := (1 to: 12) collect: [ :index |
		| obj handle |
		obj := Object new.
		handle := registry register: obj.
		registry retain: obj.
		handle ].

	System globalGarbageCollect.
	[ Processor finalizeCycle ] whileTrue: [].

	self assert: (registry objectFor: (handles at: 1) ifAbsent: [ #absent ]) equals: #absent.
	self assert: (registry objectFor: (handles at: 2) ifAbsent: [ #absent ]) equals: #absent.
	3 to: 12 do: [ :index |
		self deny: (registry objectFor: (handles at: index) ifAbsent: [ #absent ]) == #absent ]
]
