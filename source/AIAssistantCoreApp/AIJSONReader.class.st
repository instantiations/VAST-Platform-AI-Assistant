Class {
	#name : 'AIJSONReader',
	#superclass : 'NeoJSONReader',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'private',
  #vaVisibility : 'private' }
AIJSONReader >> stringStreamContents: block [

	(stringStream isKindOf: UnicodeWriteStream) ifTrue: [
		stringStream := nil ].
	^ super stringStreamContents: block
]
