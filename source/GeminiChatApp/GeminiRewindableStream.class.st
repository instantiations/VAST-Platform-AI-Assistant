Class {
	#name : 'GeminiRewindableStream',
	#superclass : 'Object',
	#instVars : [
		'stream',
		'rewindBufferSizeLimit',
		'rewindBuffer',
		'rewindBufferPosition'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiRewindableStream class >> on: stream [

	^ self on: stream rewindLimit: nil
]

{ #category : 'Not categorized' }
GeminiRewindableStream class >> on: stream rewindLimit: rewindLimit [

	^ self basicNew initializeWithStream: stream rewindLimit: rewindLimit
]

{ #category : 'Not categorized' }
GeminiRewindableStream >> atEnd [

	^ (rewindBufferPosition = rewindBuffer size) and: [ stream atEnd ]
]

{ #category : 'Not categorized' }
GeminiRewindableStream >> initializeWithStream: initialStream rewindLimit: initialRewindBufferSizeLimit [

	self initialize.
	stream := initialStream.
	rewindBufferSizeLimit := initialRewindBufferSizeLimit.
	rewindBuffer := OrderedCollection new.
	rewindBufferPosition := 0.
]

{ #category : 'Not categorized' }
GeminiRewindableStream >> next [

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
GeminiRewindableStream >> position [

	^ stream position - (rewindBuffer size - rewindBufferPosition)
]

{ #category : 'Not categorized' }
GeminiRewindableStream >> position: newPosition [

	self skip: newPosition - self position
]

{ #category : 'Not categorized' }
GeminiRewindableStream >> skip: integer [

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
