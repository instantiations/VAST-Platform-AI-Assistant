Extension {
	#name : 'RemoveClassChange'
}

{ #category : 'accessing' }
RemoveClassChange >> displayInMergeBrowser: aBrowser [
	| cls leftString |
	cls := self changeClass.
	leftString := (cls ifNil: [''] ifNotNil: [cls definitionString]).
	leftString := EmTextCompatibilityFilter sourceFilter filter: leftString.
	aBrowser updateDiffViewLeft: leftString right: ''.
]

{ #category : 'accessing' }
RemoveClassChange >> entityRepresentationKey [

	^ className
]

{ #category : 'accessing' }
RemoveClassChange >> isClassChange [
	^true
]

{ #category : 'accessing' }
RemoveClassChange >> listviewDisplayString [

	^ className
]

{ #category : 'accessing' }
RemoveClassChange >> sortPriority [
	^ 200
]
