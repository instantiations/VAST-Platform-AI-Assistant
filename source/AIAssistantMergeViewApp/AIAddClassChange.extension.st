Extension {
	#name : 'AIAddClassChange'
}

{ #category : 'accessing' }
AIAddClassChange >> displayInMergeBrowser: aBrowser [
	| cls leftString rightString |
	cls := self changeClass.
	leftString := (cls ifNil: [''] ifNotNil: [cls definitionString]).
	rightString := self definition.
	rightString := EmTextCompatibilityFilter sourceFilter filter: rightString.
	aBrowser updateDiffViewLeft: leftString right: rightString
]

{ #category : 'accessing' }
AIAddClassChange >> entityRepresentationKey [

	^ className
]

{ #category : 'AI Extensions' }
AIAddClassChange >> executeWithController: aController [

	controller := aController.
	[ ^self execute ] ensure: [ controller := nil ]
]

{ #category : 'accessing' }
AIAddClassChange >> listviewDisplayString [

	^ '<definition>'
]
