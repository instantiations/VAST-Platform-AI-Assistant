Class {
	#name : 'AIFunctionListClassesInApplicationsTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Helpers',
  #vaVisibility : 'private' }
AIFunctionListClassesInApplicationsTest >> assertListedClassesForApplicationMatchesExpected: anApplication [

	| expected returnedClasses |
	expected := self expectedClassNamesFor: anApplication.
	returnedClasses := self listedClassNamesForApplication: anApplication.
	self assert: returnedClasses size equals: expected size.
	expected do: [:cls | self assert: (returnedClasses includes: cls)].
]

{ #category : 'Helpers',
  #vaVisibility : 'private' }
AIFunctionListClassesInApplicationsTest >> expectedClassNamesFor: anApplication [

	| expected |
	expected := Set new.
	anApplication withAllSubApplications do: [:sub |
		expected
			addAll: (sub defined collect: [:cls | cls name asString]);
			addAll: (sub extended collect: [:cls | cls name asString])].
	^expected
]

{ #category : 'Helpers',
  #vaVisibility : 'private' }
AIFunctionListClassesInApplicationsTest >> listClassesInApplicationsNamed: applicationNames [

	^self
		applyFunction: AIFunctionListClassesInApplications
		withArguments: (Dictionary new
			at: 'applications' put: applicationNames;
			yourself)
]

{ #category : 'Helpers',
  #vaVisibility : 'private' }
AIFunctionListClassesInApplicationsTest >> listedClassNamesForApplication: anApplication [

	| result |
	result := self listClassesInApplicationsNamed: (Array with: anApplication name asString).
	^((result at: 'classes_per_application') at: anApplication name asString)
		collect: [:each | each asString]
]

{ #category : 'Tests' }
AIFunctionListClassesInApplicationsTest >> testIncludesExtendedAndDefinedClasses [

	| appWithExtensions returnedClasses |
	appWithExtensions := System loadedApplications detect: [:app | app extended notEmpty and:[ app defined notEmpty ]].
	returnedClasses := self listedClassNamesForApplication: appWithExtensions.
	appWithExtensions extended do: [:cls | self assert: (returnedClasses includes: cls name asString)].
	appWithExtensions defined do: [:cls | self assert: (returnedClasses includes: cls name asString)].
	self assert: returnedClasses size equals: (appWithExtensions extended, appWithExtensions defined) size 
]

{ #category : 'Tests' }
AIFunctionListClassesInApplicationsTest >> testMultipleApplications [

	| app1 app2 appNames result |
	app1 := System loadedApplications first.
	app2 := System loadedApplications last.
	appNames := Array with: app1 name asString with: app2 name asString.
	result := self listClassesInApplicationsNamed: appNames.
	self assert: (result at: 'classes_per_application') keys asArray equals: appNames
]

{ #category : 'Tests' }
AIFunctionListClassesInApplicationsTest >> testSubApplicationExcludesSiblings [

	| rootApp subApp1 |
	rootApp := System loadedApplications detect: [:app | app subApplications size >= 2].
	subApp1 := rootApp subApplications first.
	self assertListedClassesForApplicationMatchesExpected: subApp1.
]

{ #category : 'Tests' }
AIFunctionListClassesInApplicationsTest >> testSubApplicationIncludesNestedSubApplications [

	| subApp |
	subApp := System loadedSubApplications
		detect: [:app |
			app isSubApplication and: [
				app subApplications anySatisfy: [:nested | nested defined notEmpty]]].

	self assertListedClassesForApplicationMatchesExpected: subApp.
]

{ #category : 'Tests' }
AIFunctionListClassesInApplicationsTest >> testTopLevelApplicationIncludesSubApplications [

	| rootApp |
	rootApp := System loadedApplications
		detect: [:app | app subApplications anySatisfy: [:sub | sub defined notEmpty]].

	self assertListedClassesForApplicationMatchesExpected: rootApp.
]

{ #category : 'Tests' }
AIFunctionListClassesInApplicationsTest >> testUnknownApplication [

	| result |
	result := self listClassesInApplicationsNamed: #('SomeNonExistentApp123').
	self assert: (result at: 'classes_per_application') isEmpty.
	self assert: (result at: 'nonexistent_or_outside_scope_applications') asArray equals: #('SomeNonExistentApp123')
]
