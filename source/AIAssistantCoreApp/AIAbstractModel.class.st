Class {
	#name : 'AIAbstractModel',
	#superclass : 'Object',
	#instVars : [
		'provider',
		'label',
		'contextWindowSize',
		'name'
	],
	#classVars : [
		'DefaultModel',
		'RegisteredModels'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Accessing' }
AIAbstractModel class >> default [

	DefaultModel
		ifNil: [DefaultModel := self registeredModels isEmpty ifFalse: [self registeredModels first]].
	^DefaultModel
]

{ #category : 'Accessing' }
AIAbstractModel class >> default: model [

	DefaultModel := model
]

{ #category : 'Accessing' }
AIAbstractModel class >> labeled: aModelLabel [

	^RegisteredModels isNil ifFalse: [RegisteredModels at: aModelLabel ifAbsent: [nil]]
]

{ #category : 'Instance Creation' }
AIAbstractModel class >> name: modelName label: label provider: aProvider [

	^ self name: modelName label: label provider: aProvider contextWindowSize: nil
]

{ #category : 'Instance Creation' }
AIAbstractModel class >> name: modelName label: label provider: aProvider contextWindowSize: aContextWindowSize [

	^ self basicNew initializeWithName: modelName label: label provider: aProvider contextWindowSize: aContextWindowSize
]

{ #category : 'Accessing' }
AIAbstractModel class >> registerModel: aModel [

	| added |

	RegisteredModels isNil ifTrue: [RegisteredModels := Dictionary new].
	added := false.
	(RegisteredModels includesKey: aModel label) ifFalse: [
		RegisteredModels at: aModel label put: aModel beforeIndex: ((1 to: RegisteredModels size)
			detect: [ :index | (RegisteredModels keyAtIndex: index) > aModel label]
			ifNone: [RegisteredModels size + 1]).
		added := true].

	^added
		ifTrue: [
			self changed: #registeredModelsChanged.
			aModel]
		ifFalse: [self error: 'A model is already registered with this label']
]

{ #category : 'Accessing' }
AIAbstractModel class >> registeredModels [

	RegisteredModels isNil ifTrue: [RegisteredModels := EsOrderedDictionary new].
	^RegisteredModels values
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractModel class >> reset [

	RegisteredModels := nil.
	DefaultModel := nil.
]

{ #category : 'Accessing' }
AIAbstractModel class >> unregisterModel: aModel [

	| removed |

	removed := RegisteredModels removeKey: aModel label ifAbsent: [^nil].
	self default = aModel ifTrue: [self default: nil].
	self changed: #registeredModelsChanged.
	^removed
]

{ #category : 'Accessing' }
AIAbstractModel class >> unregisterModels: aModelCollection [

	| removedLabels unremovable |
	aModelCollection isEmpty ifTrue: [^#()].
	removedLabels := aModelCollection collect: [:each | each label].
	unremovable := OrderedCollection new.

	RegisteredModels
		removeAllKeys: removedLabels
		ifAbsent: [:notPresent | unremovable add: notPresent].
	removedLabels removeAll: unremovable.
	removedLabels isEmpty ifFalse: [self changed: #registeredModelsChanged].
	^removedLabels
]

{ #category : 'Accessing' }
AIAbstractModel class >> updateModel: aModel to: anotherModel [

	| isRegistered requiresReregistration |

	requiresReregistration :=
		(isRegistered := (self labeled: aModel label) = aModel)
			and: [aModel label ~= anotherModel label].
	requiresReregistration
		ifTrue: [
			(self labeled: anotherModel label) isNil
				ifFalse: [^self error: 'Another model is registered with this label'].
			RegisteredModels removeKey: aModel label].
	aModel copyStateFrom: anotherModel.
	requiresReregistration ifTrue: [
		RegisteredModels at: aModel label put: aModel beforeIndex: ((1 to: RegisteredModels size)
			detect: [ :index | (RegisteredModels keyAtIndex: index) > aModel label]
			ifNone: [RegisteredModels size + 1])].
	isRegistered ifTrue: [self changed: #registeredModelsChanged].
	^aModel
]

{ #category : 'Accessing' }
AIAbstractModel >> contextWindowSize [
	^contextWindowSize
]

{ #category : 'Initialization' }
AIAbstractModel >> copyStateFrom: anotherModel [

	label := anotherModel label.
	contextWindowSize := anotherModel contextWindowSize.
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractModel >> generatorClass [

	^ provider generatorClass
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIAbstractModel >> initializeWithName: initialName label: initialLabel provider: aProvider contextWindowSize: tokens [

	self initialize.
	name := initialName.
	label := initialLabel.
	provider := aProvider.
	contextWindowSize := tokens
]

{ #category : 'Accessing' }
AIAbstractModel >> label [

	^ label
]

{ #category : 'Accessing' }
AIAbstractModel >> label: aLabel [

	label := aLabel
]

{ #category : 'Accessing' }
AIAbstractModel >> name [

	^ name
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractModel >> provider [
	^provider
]

{ #category : 'Accessing' }
AIAbstractModel >> requestCredentials [

	^provider requestCredentials
]

{ #category : 'Accessing' }
AIAbstractModel >> requestHeaders [

	^provider requestHeaders
]

{ #category : 'Comparing' }
AIAbstractModel >> sameAs: anotherModel [

	^self class == anotherModel class and: [
		name = anotherModel name
			and: [label = anotherModel label]]
]

{ #category : 'Accessing' }
AIAbstractModel >> urlAPI [

	^provider urlAPIFor: self
]
