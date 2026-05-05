Class {
	#name : 'AIChatGenerationLog',
	#superclass : 'Object',
	#instVars : [
		'limit',
		'entriesMutex',
		'entries'
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
AIChatGenerationLog class >> limit: limit [

	^ self basicNew initializeWithLimit: limit
]

{ #category : 'Instance Creation' }
AIChatGenerationLog class >> new [

	^ AIChatGenerationLog limit: 1000
]

{ #category : 'Accessing' }
AIChatGenerationLog class >> resetCurrent [

	self current: AIChatGenerationLog new
]

{ #category : 'Not categorized' }
AIChatGenerationLog >> addEntry: entry [

	entriesMutex critical: [
		entries addLast: entry.
		entries size > limit ifTrue: [
			entries removeFirst ] ]
]

{ #category : 'Not categorized' }
AIChatGenerationLog >> entries [

	^ entriesMutex critical: [ entries copy ]
]

{ #category : 'Not categorized' }
AIChatGenerationLog >> initializeWithLimit: initialLimit [

	self initialize.
	limit := initialLimit.
	entriesMutex := Semaphore forMutualExclusion.
	entries := OrderedCollection new.
]
