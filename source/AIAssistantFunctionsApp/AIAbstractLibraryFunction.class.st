Class {
	#name : 'AIAbstractLibraryFunction',
	#superclass : 'AIAbstractFunction',
	#instVars : [
		'envyInterface'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIAbstractLibraryFunction class >> isAbstract [
	^ self == AIAbstractLibraryFunction or: [ super isAbstract ]
]

{ #category : 'Accessing' }
AIAbstractLibraryFunction >> category [

	^ 'ENVY Editions Exploration'
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractLibraryFunction >> configurationMapClass [
	^ EmConfigurationMap
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractLibraryFunction >> envyInterface [
	^ envyInterface ifNil: [EmInterface current]
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractLibraryFunction >> envyInterface: anEmInterface [

	envyInterface := anEmInterface
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIAbstractLibraryFunction >> loadedSubApplications [
	^ System image loadedSubApplications
]
