Extension {
	#name : 'RemoveMethodChange'
}

{ #category : 'accessing' }
RemoveMethodChange >> displayInMergeBrowser: aBrowser [
	aBrowser updateDiffViewLeft: (self originalMethodSourceWithCategoriesFor: self selector) right: ''.
]

{ #category : 'accessing' }
RemoveMethodChange >> entityRepresentationKey [

	^ className,'>>#',self selector
]

{ #category : 'accessing' }
RemoveMethodChange >> isMethodChange [
	^true
]

{ #category : 'accessing' }
RemoveMethodChange >> listviewDisplayString [

	^ selector asString
]

{ #category : 'accessing' }
RemoveMethodChange >> sortPriority [

	^ 150
]
