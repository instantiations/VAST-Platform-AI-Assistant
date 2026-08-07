Extension {
	#name : 'AIRemoveMethodChange'
}

{ #category : 'accessing' }
AIRemoveMethodChange >> displayInMergeBrowser: aBrowser [
	aBrowser updateDiffViewLeft: (self originalMethodSourceWithCategoriesFor: self selector) right: ''.
]

{ #category : 'accessing' }
AIRemoveMethodChange >> entityRepresentationKey [

	^className , (self isMeta ifTrue: [' class'] ifFalse: ['']) , '>>#' , self selector
]

{ #category : 'accessing' }
AIRemoveMethodChange >> listviewDisplayString [

	^ selector asString
]

{ #category : 'accessing' }
AIRemoveMethodChange >> sortPriority [

	^ 150
]
