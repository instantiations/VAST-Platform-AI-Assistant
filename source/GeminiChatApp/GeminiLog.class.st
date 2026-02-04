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

{ #category : 'Not categorized' }
GeminiLog class >> current [

	^ current
]

{ #category : 'Not categorized' }
GeminiLog class >> current: newLog [

	current := newLog
]

{ #category : 'Not categorized' }
GeminiLog class >> limit: limit [

	^ self basicNew initializeWithLimit: limit
]

{ #category : 'Not categorized' }
GeminiLog class >> new [

	^ GeminiLog limit: 1000
]

{ #category : 'Not categorized' }
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
