Class {
	#name : 'AIChatGenerationLog',
	#superclass : 'Object',
	#instVars : [
		'entriesMutex',
		'entries',
		'retainedObjectSizeAndEntryCounts',
		'totalSize',
		'sizeLimit'
	],
	#classInstVars : [
		'current'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Accessing' }
AIChatGenerationLog class >> clearCurrent [

	self current: nil
]

{ #category : 'Accessing' }
AIChatGenerationLog class >> current [

	^ current
]

{ #category : 'Accessing' }
AIChatGenerationLog class >> current: newLog [

	current := newLog
]

{ #category : 'Instance Creation' }
AIChatGenerationLog class >> new [

	^ AIChatGenerationLog sizeLimit: 50000000
]

{ #category : 'Accessing' }
AIChatGenerationLog class >> resetCurrent [

	self current: AIChatGenerationLog new
]

{ #category : 'Instance Creation' }
AIChatGenerationLog class >> sizeLimit: sizeLimit [

	^ self basicNew initializeWithSizeLimit: sizeLimit
]

{ #category : 'Not categorized' }
AIChatGenerationLog >> addEntry: entry [

	entriesMutex critical: [
		self basicAddEntry: entry.
		[ totalSize > sizeLimit ] whileTrue: [
			self basicRemoveEntry ] ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGenerationLog >> basicAddEntry: entry [

	entries addLast: entry.
	totalSize := totalSize + entry retainedObjects sizeInBytesWithHeader.
	entry retainedObjects do: [ :retainedObject |
		| bucket sizeAndEntryCount |
		bucket := self retainedObjectSizeAndEntryCountBucketFor: retainedObject.
		sizeAndEntryCount := bucket at: retainedObject ifAbsentPut: [
			| objectSize |
			objectSize := retainedObject sizeInBytesWithHeader.
			totalSize := totalSize + objectSize.
			Association key: objectSize value: 0 ].
		sizeAndEntryCount value: sizeAndEntryCount value + 1 ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGenerationLog >> basicRemoveEntry [

	| entry |

	entry := entries removeFirst.
	totalSize := totalSize - entry retainedObjects sizeInBytesWithHeader.
	entry retainedObjects do: [ :retainedObject |
		| bucket sizeAndEntryCount |
		bucket := self retainedObjectSizeAndEntryCountBucketFor: retainedObject.
		sizeAndEntryCount := bucket at: retainedObject.
		sizeAndEntryCount value = 1
			ifTrue: [
				totalSize := totalSize - sizeAndEntryCount key.
				bucket removeKey: retainedObject ]
			ifFalse: [
				sizeAndEntryCount value: sizeAndEntryCount value - 1 ] ].
	^ entry
]

{ #category : 'Not categorized' }
AIChatGenerationLog >> entries [

	^ entriesMutex critical: [ entries copy ]
]

{ #category : 'Not categorized' }
AIChatGenerationLog >> initializeWithSizeLimit: initialSizeLimit [

	self initialize.
	entriesMutex := Semaphore forMutualExclusion.
	entries := OrderedCollection new.
	retainedObjectSizeAndEntryCounts := Array new: (initialSizeLimit // 1000000 max: 1).
	1 to: retainedObjectSizeAndEntryCounts size do: [ :index |
		retainedObjectSizeAndEntryCounts at: index put: IdentityDictionary new ].
	totalSize := 0.
	sizeLimit := initialSizeLimit.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatGenerationLog >> retainedObjectSizeAndEntryCountBucketFor: object [

	^ retainedObjectSizeAndEntryCounts at: (object basicHash \\ retainedObjectSizeAndEntryCounts size + 1)
]

{ #category : 'Not categorized' }
AIChatGenerationLog >> totalSize [

	^ totalSize
]
