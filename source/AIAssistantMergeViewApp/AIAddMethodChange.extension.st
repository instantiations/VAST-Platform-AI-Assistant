Extension {
	#name : 'AIAddMethodChange'
}

{ #category : 'accessing' }
AIAddMethodChange >> displayInMergeBrowser: aBrowser [
	| origSource newSource |
	origSource := self originalMethodSourceWithCategoriesFor: self selector.
	newSource := self formattedSource: self source withCategories: self protocols.
	aBrowser updateDiffViewLeft: origSource right: newSource.
]

{ #category : 'accessing' }
AIAddMethodChange >> entityRepresentationKey [

	^className , (self isMeta ifTrue: [' class'] ifFalse: ['']) , '>>#' , self selector
]

{ #category : 'accessing' }
AIAddMethodChange >> listviewDisplayString [

	^ selector asString
]

{ #category : 'accessing' }
AIAddMethodChange >> source [
	^source
]
