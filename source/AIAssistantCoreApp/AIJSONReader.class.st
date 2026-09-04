Class {
	#name : 'AIJSONReader',
	#superclass : 'NeoJSONReader',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'private',
  #vaVisibility : 'private' }
AIJSONReader >> characterClass [

	^ Grapheme
]

{ #category : 'private',
  #vaVisibility : 'private' }
AIJSONReader >> characterOrGraphemeFor: grapheme [

	^ grapheme codePoint <= 127
		ifTrue: [ Character codePoint: grapheme codePoint ]
		ifFalse: [ grapheme ]
]

{ #category : 'private',
  #vaVisibility : 'private' }
AIJSONReader >> parseCharacterHex [

	^ self characterOrGraphemeFor: super parseCharacterHex
]

{ #category : 'private',
  #vaVisibility : 'private' }
AIJSONReader >> stringStreamContents: block [

	(stringStream isKindOf: UnicodeWriteStream) ifTrue: [
		stringStream := nil ].
	^ super stringStreamContents: block
]

{ #category : 'private',
  #vaVisibility : 'private' }
AIJSONReader >> unescapeChar: char [

	^ self characterOrGraphemeFor: (super unescapeChar: char)
]
