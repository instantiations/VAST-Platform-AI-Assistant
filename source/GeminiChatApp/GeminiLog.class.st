Class {
	#name : 'GeminiLog',
	#superclass : 'Object',
	#instVars : [
		'limit',
		'entriesMutex',
		'entries'
	],
	#classInstVars : [
		'current'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Accessing' }
GeminiLog class >> clearCurrent [

	self current: nil
]

{ #category : 'Accessing' }
GeminiLog class >> current [

	^ current
]

{ #category : 'Accessing' }
GeminiLog class >> current: newLog [

	current := newLog
]

{ #category : 'Instance Creation' }
GeminiLog class >> limit: limit [

	^ self basicNew initializeWithLimit: limit
]

{ #category : 'Instance Creation' }
GeminiLog class >> new [

	^ GeminiLog limit: 1000
]

{ #category : 'Accessing' }
GeminiLog class >> resetCurrent [

	self current: GeminiLog new
]

{ #category : 'Not categorized' }
GeminiLog >> addEntry: entry [

	entriesMutex critical: [
		entries addLast: entry.
		entries size > limit ifTrue: [
			entries removeFirst ] ]
]

{ #category : 'Not categorized' }
GeminiLog >> entries [

	^ entriesMutex critical: [ entries copy ]
]

{ #category : 'Not categorized' }
GeminiLog >> initializeWithLimit: initialLimit [

	self initialize.
	limit := initialLimit.
	entriesMutex := Semaphore forMutualExclusion.
	entries := OrderedCollection new.
]
