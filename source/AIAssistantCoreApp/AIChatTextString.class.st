Class {
	#name : 'AIChatTextString',
	#superclass : 'Object',
	#instVars : [
		'string',
		'layout'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextString class >> string: string [

	^ self basicNew initializeWithString: string
]

{ #category : 'Not categorized' }
AIChatTextString >> initializeWithString: initialString [

	self initialize.
	string := initialString.
]

{ #category : 'Not categorized' }
AIChatTextString >> layout [

	^ layout
]

{ #category : 'Not categorized' }
AIChatTextString >> layout: newLayout [

	layout := newLayout
]

{ #category : 'Not categorized' }
AIChatTextString >> resetLayout [

	self layout: nil
]

{ #category : 'Not categorized' }
AIChatTextString >> string [

	^ string
]
