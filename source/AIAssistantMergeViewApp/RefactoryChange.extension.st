Extension {
	#name : 'RefactoryChange'
}

{ #category : 'AI Extensions' }
RefactoryChange >> executeWithController: aController [

	^ self execute
]

{ #category : 'accessing' }
RefactoryChange >> isClassChange [
	^false
]

{ #category : 'accessing' }
RefactoryChange >> isMethodChange [
	^false
]

{ #category : 'accessing' }
RefactoryChange >> listviewDisplayString [

	self subclassResponsibility
]

{ #category : 'accessing' }
RefactoryChange >> sortPriority [
	^ 100
]

{ #category : 'accessing' }
RefactoryChange >> sortPriorityAgainst: aChange [

	^ self sortPriority = aChange sortPriority
		ifTrue: [ self listviewDisplayString <= aChange listviewDisplayString ]
		ifFalse: [ self sortPriority < aChange sortPriority ]
]
