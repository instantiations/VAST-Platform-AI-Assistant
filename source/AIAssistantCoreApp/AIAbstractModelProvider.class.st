Class {
	#name : 'AIAbstractModelProvider',
	#superclass : 'Object',
	#instVars : [
		'label',
		'baseUrl',
		'apiKey',
		'models'
	],
	#classVars : [
		'RegisteredProviders'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Accessing' }
AIAbstractModelProvider class >> apiLabel [
	^self subclassResponsibility
]

{ #category : 'Instance Creation' }
AIAbstractModelProvider class >> createNamed: aLabel baseUrl: aString [
	"Create a new provider with the provided string as the baseUrl where an AI chat API can be found"

	| url |

	url := SstUrl fromString: (self hasUniqueURL ifTrue: [self uniqueURL] ifFalse: [aString]).
	^self basicNew initializeLabel: aLabel baseUrl: url
]

{ #category : 'Instance Creation' }
AIAbstractModelProvider class >> hasUniqueURL [
	"Some providers really only have one implementor. These should have the baseUrl set at creation, and never changed after"
	^false
]

{ #category : 'Instance Creation' }
AIAbstractModelProvider class >> implementorLabeled: aLabel [
	^self subclasses detect: [:one | one apiLabel = aLabel] ifNone: [nil]
]

{ #category : 'Accessing' }
AIAbstractModelProvider class >> labeled: aProviderLabel [

	^RegisteredProviders isNil ifFalse: [RegisteredProviders at: aProviderLabel ifAbsent: [nil]]
]

{ #category : 'Accessing' }
AIAbstractModelProvider class >> registerProvider: aProvider [
	"Add provider, if equivalent provider is not already registered.
	 Equivalent = same class if provider should be unique, otherwise with same label"

	| added |

	RegisteredProviders isNil ifTrue: [RegisteredProviders := EsOrderedDictionary new].
	added := false.
	(RegisteredProviders includesKey: aProvider label) ifFalse: [
		RegisteredProviders at: aProvider label put: aProvider beforeIndex: ((1 to: RegisteredProviders size)
			detect: [ :index | (RegisteredProviders keyAtIndex: index) > aProvider label]
			ifNone: [RegisteredProviders size + 1]).
		added := true].

	^added
		ifTrue: [
			self changed: #registeredProvidersChanged.
			aProvider]
		ifFalse: [self error: 'A provider is already registered with this label']
]

{ #category : 'Accessing' }
AIAbstractModelProvider class >> registeredProviders [

	RegisteredProviders isNil ifTrue: [RegisteredProviders := EsOrderedDictionary new].
	^RegisteredProviders values
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractModelProvider class >> reset [
	RegisteredProviders := nil
]

{ #category : 'Instance Creation',
  #vaVisibility : 'private' }
AIAbstractModelProvider class >> uniqueURL [
	"Implement this on subclasses for which hasUniqueURL returns true"
	^self subclassResponsibility
]

{ #category : 'Accessing' }
AIAbstractModelProvider class >> unregisterProvider: aProvider ifUnregisteringModels: unregisteringModelsBlock [

	| registeredModels removed |

	registeredModels :=
		AIAbstractModel registeredModels select: [:each | each provider = aProvider].
	registeredModels ifNotEmpty: [
		(unregisteringModelsBlock cull: registeredModels) ifFalse: [^self]].
	registeredModels do: [:each | AIAbstractModel unregisterModel: each].
	removed := RegisteredProviders removeKey: aProvider label ifAbsent: [^nil].
	self changed: #registeredProvidersChanged.
	^removed
]

{ #category : 'Accessing' }
AIAbstractModelProvider class >> updateProvider: aProvider to: anotherProvider [
	"Update aProvider with details from anotherProvider.
	 If aProvider is registered, send a change event"

	| isRegistered requiresReregistration |

	requiresReregistration :=
		(isRegistered := (self labeled: aProvider label) = aProvider)
			and: [aProvider label ~= anotherProvider label].
	requiresReregistration
		ifTrue: [
			(self labeled: anotherProvider label) isNil
				ifFalse: [^self error: 'Another provider is registered with this label'].
			RegisteredProviders removeKey: aProvider label].
	aProvider copyStateFrom: anotherProvider.
	requiresReregistration ifTrue: [
		RegisteredProviders at: aProvider label put: aProvider beforeIndex: ((1 to: RegisteredProviders size)
			detect: [ :index | (RegisteredProviders keyAtIndex: index) > aProvider label]
			ifNone: [RegisteredProviders size + 1])].
	isRegistered ifTrue: [self changed: #registeredProvidersChanged].
	^aProvider
]

{ #category : 'Accessing' }
AIAbstractModelProvider >> apiKey [

	^apiKey
]

{ #category : 'Accessing' }
AIAbstractModelProvider >> apiKey: aString [
	"Set nil if empty string"
	apiKey := aString isEmpty ifFalse: [aString]
]

{ #category : 'Accessing' }
AIAbstractModelProvider >> baseUrl [

	^baseUrl copy
]

{ #category : 'Accessing' }
AIAbstractModelProvider >> baseUrl: aNewSstUrl [

	^self class hasUniqueURL ifFalse: [baseUrl := aNewSstUrl]
]

{ #category : 'Endpoints',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> basicGetModels [

	| httpClient byteContents stream |

	(httpClient := SstHttpClient forTransportScheme: self urlModels localEndpointUrl transport)
		proxyEnabled: true.
	[| responseOrError |
		responseOrError :=
			httpClient
				get: self urlModels
				using: self requestCredentials
				withHeaders: self requestHeaders.

		responseOrError isSstError
			ifTrue: [
				self handleSstError: responseOrError.
				^nil].
		byteContents := responseOrError contents asByteArray]
			ensure: [httpClient shutDown].
	stream :=
		AIPeekableStream on: (
			AICharacterGraphemeStream on: (AIUTF8DecodingStream on: byteContents readStream)).
	^(NeoJSONReader on: stream) next
]

{ #category : 'Initialization' }
AIAbstractModelProvider >> copyStateFrom: anotherProvider [

	| newModels |

	label := anotherProvider label.
	baseUrl := anotherProvider baseUrl.
	apiKey := anotherProvider apiKey.
	"Create new models with self as provider"
	newModels :=
		anotherProvider models
			collect: [:each | (each class name: each name label: each label provider: self) copyStateFrom: each].
	self updateModelsFrom: newModels
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> generatorClass [

	^self subclassResponsibility
]

{ #category : 'Models' }
AIAbstractModelProvider >> getModels [

	^self parseModels: (self basicGetModels)
]

{ #category : 'Errors',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> handleSstError: anError [
	"Some sst errors are raised, others return error objects. 
	 Raise any error object returns here, so my users can use error handling blocks consistently"
	anError raise
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> initializeLabel: aLabel baseUrl: aUrl [

	label := aLabel.
	baseUrl := aUrl
]

{ #category : 'Accessing' }
AIAbstractModelProvider >> label	 [
	^label
]

{ #category : 'Accessing' }
AIAbstractModelProvider >> label: newLabel [
	label := newLabel
]

{ #category : 'Models' }
AIAbstractModelProvider >> models [

	^models ifNil: [models := OrderedCollection new]
]

{ #category : 'Models',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> parseModels: aJSONObject [

	^self subclassResponsibility
]

{ #category : 'Initialization' }
AIAbstractModelProvider >> postCopy [
	models := models copy
]

{ #category : 'Models' }
AIAbstractModelProvider >> refreshModels [

	^self updateModelsFrom:  self getModels.

]

{ #category : 'Endpoints' }
AIAbstractModelProvider >> requestCredentials [
	"Some providers use basic auth credentials to pass the api key"
	^self subclassResponsibility
]

{ #category : 'Endpoints' }
AIAbstractModelProvider >> requestHeaders [
	"Some providers use custom headers to pass the api key"
	^self subclassResponsibility
]

{ #category : 'Comparing' }
AIAbstractModelProvider >> sameAs: anotherProvider [

	^self class = anotherProvider class and: [
		label = anotherProvider label and: [
			baseUrl = anotherProvider baseUrl
				and: [apiKey = anotherProvider apiKey and: [self sameModelsAs: anotherProvider]]]]
]

{ #category : 'Comparing',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> sameModelsAs: anotherProvider [
	self models size = anotherProvider models size ifFalse: [^false].
	self models
		with: anotherProvider models
		do: [:myModel :theirModel | (myModel name = theirModel name) ifFalse: [^false]].
	^true
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> updateModelsFrom: newModelCollection [
	"Update based on modelNames - which are immutable. 
	 Provider of the models must already be self.
	 Add/remove new/obsolete models"
	| toRemove toAdd registeredToRemove |

	toRemove := self models reject: [:each | newModelCollection contains: [:one | one name = each name]].
	toAdd := newModelCollection reject: [:each | self models contains: [:one | one name = each name]].
	self models addAll: toAdd.
	registeredToRemove :=
		AIAbstractModel registeredModels select: [:each | toRemove contains: [:one | one name = each name]].
	AIAbstractModel unregisterModels: registeredToRemove.
	self models removeAll: toRemove.
	^models := self models sorted: [:a :b | a label < b label]
]

{ #category : 'Endpoints' }
AIAbstractModelProvider >> urlAPIFor: aModel [
	^self subclassResponsibility
]

{ #category : 'Endpoints',
  #vaVisibility : 'private' }
AIAbstractModelProvider >> urlModels [

	^self subclassResponsibility
]
