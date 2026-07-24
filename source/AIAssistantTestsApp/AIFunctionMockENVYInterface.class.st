Class {
	#name : 'AIFunctionMockENVYInterface',
	#superclass : 'Object',
	#instVars : [
		'versionedApps',
		'versionedClasses',
		'versionedMaps',
		'logs',
		'shouldFail',
		'logCount'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Instance Creation' }
AIFunctionMockENVYInterface class >> new [

	^self basicNew initialize
]

{ #category : 'Naming' }
AIFunctionMockENVYInterface >> applicationVersionName: name alreadyUsedBy: app [

	^versionedApps includes: name
]

{ #category : 'Naming' }
AIFunctionMockENVYInterface >> classVersionName: name alreadyUsedBy: cls in: app [

	^versionedClasses includes: name
]

{ #category : 'Naming' }
AIFunctionMockENVYInterface >> configMapVersionName: name alreadyUsedBy: map [

	^versionedMaps includes: name
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIFunctionMockENVYInterface >> initialize [
	super initialize.
	versionedApps := OrderedCollection new.
	versionedClasses := OrderedCollection new.
	versionedMaps := OrderedCollection new.
	logs := OrderedCollection new.
	shouldFail := false.
	logCount := 0.

]

{ #category : 'Testing' }
AIFunctionMockENVYInterface >> isEdition: app [

	^true
]

{ #category : 'Testing' }
AIFunctionMockENVYInterface >> isVersion: app [

	^false
]

{ #category : 'Logging' }
AIFunctionMockENVYInterface >> logApplicationVersion: app [

	logCount := logCount + 1
]

{ #category : 'Logging' }
AIFunctionMockENVYInterface >> logClassVersion: cls in: app [

	logCount := logCount + 1
]

{ #category : 'Logging' }
AIFunctionMockENVYInterface >> logConfigMapVersion: map [

	logCount := logCount + 1
]

{ #category : 'Configuring' }
AIFunctionMockENVYInterface >> shouldFail: aBoolean [

	shouldFail := aBoolean
]

{ #category : 'Versioning' }
AIFunctionMockENVYInterface >> versionApplication: app withName: name [

	shouldFail ifTrue: [^false].
	versionedApps add: name.
	^true
]

{ #category : 'Versioning' }
AIFunctionMockENVYInterface >> versionClass: cls in: app withName: name [

	shouldFail ifTrue: [^false].
	versionedClasses add: name.
	^true
]

{ #category : 'Versioning' }
AIFunctionMockENVYInterface >> versionConfigMap: map withName: name [

	shouldFail ifTrue: [^false].
	versionedMaps add: name.
	^true
]
