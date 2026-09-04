Extension {
	#name : 'AIAddClassChange'
}

{ #category : 'accessing' }
AIAddClassChange >> displayInMergeBrowser: aBrowser [
	| cls leftString rightString filter |
	cls := self changeClass.
	leftString := (cls ifNil: [''] ifNotNil: [cls definitionString]).
	rightString := self definition.
	filter := EmTextCompatibilityFilter sourceFilter.
	leftString := filter filter: leftString.
	rightString := filter filter: rightString.
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
