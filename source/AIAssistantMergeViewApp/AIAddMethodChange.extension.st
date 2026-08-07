Extension {
	#name : 'AIAddMethodChange'
}

{ #category : 'accessing' }
AIAddMethodChange >> displayInMergeBrowser: aBrowser [
	| origSource newSource |
	origSource := self originalMethodSourceWithCategoriesFor: self selector.
	newSource := self formattedSource: self source withCategories: self protocols.
	newSource := EmTextCompatibilityFilter sourceFilter filter: newSource.
	aBrowser updateDiffViewLeft: origSource right: newSource.
]

{ #category : 'accessing' }
AIAddMethodChange >> entityRepresentationKey [

	^className , (self isMeta ifTrue: [' class'] ifFalse: ['']) , '>>#' , self selector
]

{ #category : 'AI extensions' }
AIAddMethodChange >> executeWithController: aController [

	controller := aController.
	[ ^self execute ] ensure: [ controller := nil ]
]

{ #category : 'accessing' }
AIAddMethodChange >> listviewDisplayString [

	^ selector asString
]

{ #category : 'accessing' }
AIAddMethodChange >> source [
	^source
]
