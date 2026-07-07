Extension {
	#name : 'AIAddClassChange'
}

{ #category : 'accessing' }
AIAddClassChange >> displayInMergeBrowser: aBrowser [
	| cls leftString rightString |
	cls := self changeClass.
	leftString := (cls ifNil: [''] ifNotNil: [cls definitionString]).
	rightString := self definition.
	aBrowser updateDiffViewLeft: leftString right: rightString
]

{ #category : 'accessing' }
AIAddClassChange >> entityRepresentationKey [

	^ className
]

{ #category : 'accessing' }
AIAddClassChange >> listviewDisplayString [

	^ '<definition>'
]
