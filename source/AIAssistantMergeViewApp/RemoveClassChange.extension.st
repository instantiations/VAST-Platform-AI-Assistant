Extension {
	#name : 'RemoveClassChange'
}

{ #category : 'accessing' }
RemoveClassChange >> displayInMergeBrowser: aBrowser [
	| cls |
	cls := self changeClass.
	aBrowser updateDiffViewLeft: (cls ifNil: [''] ifNotNil: [cls definitionString]) right: ''.
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
