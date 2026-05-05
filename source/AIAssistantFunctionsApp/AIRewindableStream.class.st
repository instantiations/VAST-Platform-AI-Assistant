Class {
	#name : 'AIRewindableStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'rewindBufferSizeLimit',
		'rewindBuffer',
		'rewindBufferPosition'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIRewindableStream class >> on: stream [

	^ self on: stream rewindLimit: nil
]

{ #category : 'Not categorized' }
AIRewindableStream class >> on: stream rewindLimit: rewindLimit [

	^ self basicNew initializeWithStream: stream rewindLimit: rewindLimit
]

{ #category : 'Not categorized' }
AIRewindableStream >> atEnd [

	^ (rewindBufferPosition = rewindBuffer size) and: [ stream atEnd ]
]

{ #category : 'Not categorized' }
AIRewindableStream >> initializeWithStream: initialStream rewindLimit: initialRewindBufferSizeLimit [

	self initialize.
	stream := initialStream.
	rewindBufferSizeLimit := initialRewindBufferSizeLimit.
	rewindBuffer := OrderedCollection new.
	rewindBufferPosition := 0.
]

{ #category : 'Not categorized' }
AIRewindableStream >> next [

	^ rewindBufferPosition = rewindBuffer size
		ifTrue: [
			stream atEnd
				ifFalse: [
					rewindBufferSizeLimit > 0
						ifTrue: [
							rewindBuffer size = rewindBufferSizeLimit ifTrue: [
								rewindBuffer removeFirst
							] ifFalse: [
								rewindBufferPosition := rewindBufferPosition + 1 ].
							rewindBuffer add: stream next ]
						ifFalse: [
							stream next ] ] ]
		ifFalse: [
			rewindBuffer at: (rewindBufferPosition := rewindBufferPosition + 1) ]
]

{ #category : 'Not categorized' }
AIRewindableStream >> position [

	^ stream position - (rewindBuffer size - rewindBufferPosition)
]

{ #category : 'Not categorized' }
AIRewindableStream >> position: newPosition [

	self skip: newPosition - self position
]

{ #category : 'Not categorized' }
AIRewindableStream >> skip: integer [

	integer < 0 ifTrue: [
		integer < rewindBufferPosition negated ifTrue: [
			Error signal: ('Cannot skip by less than %1' bindWith: rewindBufferPosition negated) ].
		rewindBufferPosition := rewindBufferPosition + integer.
	] ifFalse: [
		| rewound |
		rewound := rewindBuffer size - rewindBufferPosition.
		integer <= rewound ifTrue: [
			rewindBufferPosition := rewindBufferPosition + integer
		] ifFalse: [
			rewindBufferPosition := rewindBuffer size.
			integer - rewound timesRepeat: [ self next ] ] ]
]
