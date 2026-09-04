Class {
	#name : 'AICharacterSequenceUnicodeScalarView',
	#superclass : 'AIAbstractCharacterSequence',
	#instVars : [
		'unicodeScalarView'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AICharacterSequenceUnicodeScalarView class >> unicodeScalarView: unicodeScalarView [

	^ self basicNew initializeWithUnicodeScalarView: unicodeScalarView
]

{ #category : 'Accessing' }
AICharacterSequenceUnicodeScalarView >> at: index [

	| value |

	value := (unicodeScalarView at: index) value.
	^ value <= 127
		ifTrue: [ Character codePoint: value ]
		ifFalse: [ Grapheme codePoint: value ]
]

{ #category : 'Initialization' }
AICharacterSequenceUnicodeScalarView >> initializeWithUnicodeScalarView: initialUnicodeScalarView [

	self initialize.
	unicodeScalarView := initialUnicodeScalarView.
]

{ #category : 'Accessing' }
AICharacterSequenceUnicodeScalarView >> size [

	^ unicodeScalarView size
]

{ #category : 'Copying' }
AICharacterSequenceUnicodeScalarView >> stringFrom: startIndex to: endIndex [

	^ UnicodeString value: (unicodeScalarView copyFrom: startIndex to: endIndex) contents
]
