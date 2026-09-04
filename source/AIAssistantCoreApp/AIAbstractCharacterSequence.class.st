Class {
	#name : 'AIAbstractCharacterSequence',
	#superclass : 'Object',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIAbstractCharacterSequence class >> string: string [

	^ string isSBString
		ifTrue: [ AICharacterSequenceString string: string ]
		ifFalse: [ AICharacterSequenceUnicodeScalarView unicodeScalarView: string unicodeScalars ]
]

{ #category : 'Accessing' }
AIAbstractCharacterSequence >> at: index [

	self subclassResponsibility
]

{ #category : 'Accessing' }
AIAbstractCharacterSequence >> size [

	self subclassResponsibility
]

{ #category : 'Copying' }
AIAbstractCharacterSequence >> stringFrom: startIndex to: endIndex [

	self subclassResponsibility
]
