Class {
	#name : 'AICharacterSequenceString',
	#superclass : 'AIAbstractCharacterSequence',
	#instVars : [
		'string'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AICharacterSequenceString class >> string: string [

	^ self basicNew initializeWithString: string
]

{ #category : 'Accessing' }
AICharacterSequenceString >> at: index [

	^ string at: index
]

{ #category : 'Initialization' }
AICharacterSequenceString >> initializeWithString: initialString [

	self initialize.
	string := initialString.
]

{ #category : 'Accessing' }
AICharacterSequenceString >> size [

	^ string size
]

{ #category : 'Copying' }
AICharacterSequenceString >> stringFrom: startIndex to: endIndex [

	^ string copyFrom: startIndex to: endIndex
]
