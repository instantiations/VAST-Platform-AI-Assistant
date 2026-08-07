Class {
	#name : 'AIFunctionLibraryENVYTest',
	#superclass : 'TestCase',
	#instVars : [
		'appOne',
		'appSeveral',
		'appMany',
		'mapOne',
		'mapSeveral',
		'mapMany'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> setUp [

	super setUp.

	"1 Edition"
	appOne :=
		(Application allSubclasses
			detect: [:each | each isApplication and: [each shadows size = 1]]
			ifNone: [ nil ]) ifNotNil: [ :application | application name asString ].
	mapOne := (EmConfigurationMap configurationMapNames
		detect: [:each | (EmConfigurationMap editionsFor: each) size = 1]
		ifNone: [ nil ]).

	"Several Editions"
	appSeveral :=
		(Application allSubclasses
			detect: [:each | each isApplication and: [each shadows size > 5]]
			ifNone: [ nil ]) ifNotNil: [ :application | application name asString ].
	mapSeveral := (EmConfigurationMap configurationMapNames
		detect: [:each | (EmConfigurationMap editionsFor: each) size > 1]
		ifNone: [ nil ])
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testApplicationEditionsOne [

	| result |

	appOne ifNil: [ self skip ].

	result :=
		AIFunctionLibraryGetApplicationEditions new
			applyFunctionTo: (EsOrderedDictionary with: 'application' -> appOne)
			in: nil.
	self assert: (result includesKey: 'editions').
	self assert: (result at: 'editions') size equals: 1
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testApplicationEditionsSeveral [

	| result |

	appSeveral ifNil: [ self skip ].

	result :=
		AIFunctionLibraryGetApplicationEditions new
			applyFunctionTo: (EsOrderedDictionary with: 'application' -> appSeveral)
			in: nil.
	self assert: (result includesKey: 'editions').

	self assert: (result at: 'editions') size > 5.
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testApplicationEditionsZero [

	| result |

	result :=
		AIFunctionLibraryGetApplicationEditions new
			applyFunctionTo: (EsOrderedDictionary with: 'application' -> 'NonExistentApp')
			in: nil.
	self assert: (result includesKey: 'error')
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testCompareApplicationEditionsOne [
	"Comparing a 1-edition application effectively to itself, expecting no differences"
	| result shadowId |

	appOne ifNil: [ self skip ].

	shadowId := (Smalltalk at: appOne asSymbol) shadows first versionName ifNil: [ (Smalltalk at: appOne asSymbol) shadows first timeStamp printString ].
	result := AIFunctionLibraryCompareApplicationEditions new applyFunctionTo: (EsOrderedDictionary 
		with: 'application' -> appOne 
		with: 'edition_1_identifier' -> shadowId) in: nil.
	
	self assert: (result includesKey: 'differences').
	self assert: (result at: 'differences') equals: 'No differences found.'.

]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testCompareApplicationEditionsSeveral [
	"Comparing an older version vs a newer version of the several-editions application"

	| result shadows id1 id2 |

	appSeveral ifNil: [ self skip ].

	shadows := (Smalltalk at: appSeveral asSymbol) shadows.
	id1 := shadows last versionName ifNil: [shadows last timeStamp printString].
	id2 := shadows first versionName ifNil: [shadows first timeStamp printString].

	result :=
		AIFunctionLibraryCompareApplicationEditions new
			applyFunctionTo: (
				EsOrderedDictionary
					with: 'application' -> appSeveral
					with: 'edition_1_identifier' -> id1
					with: 'edition_2_identifier' -> id2)
			in: nil.

	self assert: (result includesKey: 'differences')
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testCompareApplicationEditionsZero [
	| result |
	result := AIFunctionLibraryCompareApplicationEditions new applyFunctionTo: (EsOrderedDictionary 
		with: 'application' -> 'NonExistentApp' 
		with: 'edition_1_identifier' -> 'v1') in: nil.
	self assert: (result includesKey: 'error').

]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testConfigurationMapEditionsOne [

	| result |

	mapOne ifNil: [ self skip ].

	result :=
		AIFunctionLibraryGetConfigurationMapEditions new
			applyFunctionTo: (EsOrderedDictionary with: 'configuration_map' -> mapOne)
			in: nil.
	self assert: (result includesKey: 'editions').
	self assert: (result at: 'editions') size equals: 1
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testConfigurationMapEditionsSeveral [

	| result |

	mapSeveral ifNil: [ self skip ].

	result :=
		AIFunctionLibraryGetConfigurationMapEditions new
			applyFunctionTo: (EsOrderedDictionary with: 'configuration_map' -> mapSeveral)
			in: nil.
	self assert: (result includesKey: 'editions').
	self assert: (result at: 'editions') size > 1.
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testConfigurationMapEditionsZero [

	| result |

	result :=
		AIFunctionLibraryGetConfigurationMapEditions new
			applyFunctionTo: (EsOrderedDictionary with: 'configuration_map' -> 'NonExistentMap')
			in: nil.
	self assert: (result includesKey: 'error')
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testMethodSourceOne [

	| result  |
	result :=
		AIFunctionLibraryGetMethodSourceInEdition new
			applyFunctionTo: (
				EsOrderedDictionary
					with: 'application' -> Kernel name asString
					with: 'class' -> Object name asString
					with: 'selector' -> 'error:')
			in: nil.

	self assert: (result includesKey: 'source').
	self assert: ((result at: 'source') includesSubString: 'ExError signalWith:')
]

{ #category : 'Not categorized' }
AIFunctionLibraryENVYTest >> testMethodSourceZero [

	| result |

	appOne ifNil: [ self skip ].

	result :=
		AIFunctionLibraryGetMethodSourceInEdition new
			applyFunctionTo: (
				EsOrderedDictionary
					with: 'application' -> appOne
					with: 'class' -> 'AIFunctionLibraryGetMethodSourceInEdition'
					with: 'selector' -> 'nonExistentMethod:in:')
			in: nil.
	self assert: (result includesKey: 'error')
]
