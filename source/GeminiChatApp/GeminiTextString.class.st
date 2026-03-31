Class {
	#name : 'GeminiTextString',
	#superclass : 'Object',
	#instVars : [
		'string',
		'layout'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextString class >> string: string [

	^ self basicNew initializeWithString: string
]

{ #category : 'Not categorized' }
GeminiTextString >> initializeWithString: initialString [

	self initialize.
	string := initialString.
]

{ #category : 'Not categorized' }
GeminiTextString >> layout [

	^ layout
]

{ #category : 'Not categorized' }
GeminiTextString >> layout: newLayout [

	layout := newLayout
]

{ #category : 'Not categorized' }
GeminiTextString >> resetLayout [

	self layout: nil
]

{ #category : 'Not categorized' }
GeminiTextString >> string [

	^ string
]
