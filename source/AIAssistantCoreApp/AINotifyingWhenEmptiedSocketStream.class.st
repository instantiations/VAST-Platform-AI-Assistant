Class {
	#name : 'AINotifyingWhenEmptiedSocketStream',
	#superclass : 'Object',
	#instVars : [
		'socketStream',
		'emptiedBlock'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AINotifyingWhenEmptiedSocketStream class >> on: socketStream [

	^ self on: socketStream whenEmptiedDo: [ ]
]

{ #category : 'Instantiation' }
AINotifyingWhenEmptiedSocketStream class >> on: socketStream whenEmptiedDo: emptiedBlock [

	^ self basicNew initializeWithSocketStream: socketStream emptiedBlock: emptiedBlock
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AINotifyingWhenEmptiedSocketStream >> checkStream [

	socketStream isEmpty ifTrue: [
		emptiedBlock value ]
]

{ #category : 'Initialization' }
AINotifyingWhenEmptiedSocketStream >> initializeWithSocketStream: initialSocketStream emptiedBlock: initialEmptiedBlock [

	self initialize.
	socketStream := initialSocketStream.
	emptiedBlock := initialEmptiedBlock.
]

{ #category : 'Accessing' }
AINotifyingWhenEmptiedSocketStream >> isBytes: boolean [

	socketStream isBytes: boolean
]

{ #category : 'Reading' }
AINotifyingWhenEmptiedSocketStream >> next [

	self checkStream.
	^ socketStream next
]

{ #category : 'Reading' }
AINotifyingWhenEmptiedSocketStream >> peek [

	self checkStream.
	^ socketStream peek
]
