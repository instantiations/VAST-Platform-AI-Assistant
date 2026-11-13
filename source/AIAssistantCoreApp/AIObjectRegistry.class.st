Class {
	#name : 'AIObjectRegistry',
	#superclass : 'Object',
	#instVars : [
		'objectsByHandle',
		'handlesByObject',
		'retainedObjects',
		'nextHandle',
		'nilHandle'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Accessing' }
AIObjectRegistry class >> maxRetainedObjects [
	"Answer the maximum number of objects that may be strongly retained at one time."

	^ 10
]

{ #category : 'Instance Creation' }
AIObjectRegistry class >> new [

	^ self newWithInitialNextHandle: 1
]

{ #category : 'Instance Creation' }
AIObjectRegistry class >> newWithInitialNextHandle: initialNextHandle [
	"Answer a new instance of the receiver initialized to assign handles starting from initialNextHandle."

	^ self basicNew initializeWithNextHandle: initialNextHandle
]

{ #category : 'Initialization' }
AIObjectRegistry >> initializeWithNextHandle: initialNextHandle [

	self initialize.
	objectsByHandle := EsWeakDictionary new.
	handlesByObject := AbtWeakKeyIdentityDictionary new.
	retainedObjects := EsQueue new: self maxRetainedObjects + 1.
	nextHandle := initialNextHandle.
	nilHandle := 0
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIObjectRegistry >> maxRetainedObjects [
	"Answer the maximum number of objects that may be strongly retained at one time."

	^ self class maxRetainedObjects
]

{ #category : 'Accessing' }
AIObjectRegistry >> nextHandle [
	"Answer the next handle that will be assigned to a newly registered object."

	^ nextHandle
]

{ #category : 'Accessing' }
AIObjectRegistry >> objectFor: aHandle ifAbsent: aBlock [
	| object absent |
	aHandle = nilHandle ifTrue: [ ^ nil ].
	absent := false.
	object := [
		| found |
		found := objectsByHandle at: aHandle ifAbsent: [
			absent := true.
			nil ].
		(absent not and: [ found isNil ]) ifTrue: [
			"The weakly-referenced object was reclaimed by the garbage collector"
			objectsByHandle removeKey: aHandle ifAbsent: [ ].
			absent := true ].
		found
	] critical.
	absent ifTrue: [ ^ aBlock value ].
	^ object
]

{ #category : 'Accessing' }
AIObjectRegistry >> register: anObject [
	"Registers anObject and returns its assigned handle."

	anObject isNil ifTrue: [ ^ nilHandle ].
	^ [
		handlesByObject
			at: anObject
			ifAbsent: [
				| handle |
				handle := nextHandle.
				nextHandle := nextHandle + 1.
				handlesByObject at: anObject put: handle.
				objectsByHandle at: handle put: anObject.
				handle ]
	] critical
]

{ #category : 'Accessing' }
AIObjectRegistry >> retain: anObject [
	"Hold a strong reference to anObject in a bounded FIFO queue (up to maxRetainedObjects),
	 evicting the oldest retained object when the limit is reached."

	anObject ifNil: [ ^ self ].
	[
		retainedObjects size >= self maxRetainedObjects ifTrue: [
			retainedObjects removeFirst ].
		retainedObjects addLast: anObject
	] critical
]
