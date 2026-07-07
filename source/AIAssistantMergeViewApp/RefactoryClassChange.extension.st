Extension {
	#name : 'RefactoryClassChange'
}

{ #category : 'private',
  #vaVisibility : 'private' }
RefactoryClassChange >> formattedSource: aSource withCategories: categories [

	aSource isEmpty ifTrue: [^aSource].
	^String streamContents: [:str |
		str nextPutAll: '"Categories: '.
		categories do: [:each | str nextPutAll: each] separatedBy: [str nextPutAll: ', '].
		str
			nextPutAll: '"';
			nextPutAll: String platformLineDelimiter;
			nextPutAll: aSource]
]

{ #category : 'private',
  #vaVisibility : 'private' }
RefactoryClassChange >> originalMethodSourceWithCategoriesFor: aSelector [

	| cls originalSource originalCategories |

	cls := self changeClass.
	originalSource := cls ifNil: [''] ifNotNil: [(self methodSourceFor: aSelector) ifNil: ['']].
	originalCategories := cls ifNil: [#()] ifNotNil: [cls categoriesFor: aSelector].

	^self formattedSource: originalSource withCategories: originalCategories
]
