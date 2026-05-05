Class {
	#name : 'AIFunctionDescribe',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionDescribe >> applyFunctionTo: arguments in: context [

	| entity global |

	entity := (arguments at: 'entity') asSymbol.
	global := self findGlobal: entity.
	^self describeGlobal: global
]

{ #category : 'Not categorized' }
AIFunctionDescribe >> describeApplication: anApplicationAssoc [

	^EsOrderedDictionary new
		at: 'application' put: anApplicationAssoc key asString;
		yourself
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIFunctionDescribe >> describeClass: aClassAssoc [

	^EsOrderedDictionary new
		at: 'class' put: aClassAssoc key asString;
		at: 'super' put: (aClassAssoc value superclass ifNotNil: [ :superclass | superclass name asString ]);
		at: 'application' put: aClassAssoc value controller name asString;
		yourself
]

{ #category : 'Not categorized' }
AIFunctionDescribe >> describeGlobal: aGlobal [

	aGlobal value isNil ifTrue: [^self describeUnknown: aGlobal].
	aGlobal value isClass
		ifTrue: [
			(aGlobal value includesBehavior: SubApplication)
				ifTrue: [^self describeApplication: aGlobal]
				ifFalse: [^self describeClass: aGlobal]].
	aGlobal value stsIsPoolDictionary ifTrue: [^self describePool: aGlobal].
	^self describeGlobalVariable: aGlobal
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIFunctionDescribe >> describeGlobalVariable: aGlobalAssoc [

	^EsOrderedDictionary new
		at: 'globalVariable' put: aGlobalAssoc key asString;
		at: 'instanceOfClass' put: aGlobalAssoc value class name asString;
		yourself
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIFunctionDescribe >> describePool: aPoolAssoc [
	"CwConstants"

	| definingMethods |

	definingMethods := OrderedCollection new.
	Smalltalk owningImage classHierarchyRoots do: [:rootClass | definingMethods addAll: (rootClass allMethodsNamed: ('_PRAGMA_' , aPoolAssoc key) asSymbol)].

	^EsOrderedDictionary new
		at: 'pool' put: aPoolAssoc key asString;
		at: 'definedIn'
			put: (
				definingMethods collect: [:each |
					EsOrderedDictionary new
						at: 'class' put: each methodClass name asString;
						at: 'selector' put: each selector asString;
						yourself]);
		yourself
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIFunctionDescribe >> describeUnknown: aGlobal [

	^EsOrderedDictionary new
		at: 'error' put: 'Unknown entity in global scope';
		yourself
]

{ #category : 'Not categorized' }
AIFunctionDescribe >> description [

	^ 'Describes a global entity in the VAST environment. The return value is correctly cased, and has a type indicating which other tools are appropriate to use.'
]

{ #category : 'Not categorized' }
AIFunctionDescribe >> findGlobal: entity [

	| value |

	value :=
		Smalltalk
			at: entity
			ifAbsent: [| entityKey |
				entityKey := entity asLowercase.
				Smalltalk keysDo: [:aKey |
					aKey asLowercase = entityKey ifTrue: [^aKey -> (Smalltalk at: aKey)]].
				nil].
	^entity -> value
]

{ #category : 'Not categorized' }
AIFunctionDescribe >> name [
	^'describe'
]

{ #category : 'Not categorized' }
AIFunctionDescribe >> parameters [

	^ {
		AIFunctionParameterRequired name: 'entity'
			type: AIFunctionParameterTypeString new
			description: 'Entity to describe - Case insentive' }
]
