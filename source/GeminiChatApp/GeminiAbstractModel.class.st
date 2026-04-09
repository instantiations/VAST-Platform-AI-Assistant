Class {
	#name : 'GeminiAbstractModel',
	#superclass : 'Object',
	#instVars : [
		'name',
		'label',
		'contextWindowSize'
	],
	#classVars : [
		'DefaultModel'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractModel class >> all [

	| allModels |

	allModels := OrderedCollection new.
	self allGrouped do: [ :groupModels |
		allModels addAll: groupModels ].
	^ allModels
]

{ #category : 'Not categorized' }
GeminiAbstractModel class >> allGrouped [

	| modelGroups |

	modelGroups := OrderedCollection new.
	GeminiChatAbstractProvider all do: [ :provider |
		provider models ifNotEmpty: [ :models |
			modelGroups add: models ] ].
	^ modelGroups
]

{ #category : 'Accessing' }
GeminiAbstractModel class >> default [

	^ DefaultModel ifNil: [ DefaultModel := self all first ]
]

{ #category : 'Accessing' }
GeminiAbstractModel class >> default: model [

	DefaultModel := model
]

{ #category : 'Accessing' }
GeminiAbstractModel class >> named: modelName [

	^ self all detect: [ :model | model name = modelName ]
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
GeminiAbstractModel class >> reset [

	DefaultModel := nil.
]

{ #category : 'Comparing' }
GeminiAbstractModel >> = otherObject [

	^ self class = otherObject class
		and: [ self name = otherObject name
		and: [ self label = otherObject label ] ]
]

{ #category : 'Accessing' }
GeminiAbstractModel >> contextWindowSize [
	^contextWindowSize
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
GeminiAbstractModel >> generatorClass [

	self subclassResponsibility
]

{ #category : 'Comparing' }
GeminiAbstractModel >> hash [

	^ self name hash xor: self label hash
]

{ #category : 'Not categorized' }
GeminiAbstractModel >> initializeWithName: initialName label: initialLabel contextWindowSize: tokens [

	self initialize.
	name := initialName.
	label := initialLabel.
	contextWindowSize := tokens
]

{ #category : 'Accessing' }
GeminiAbstractModel >> label [

	^ label
]

{ #category : 'Accessing' }
GeminiAbstractModel >> name [

	^ name
]
