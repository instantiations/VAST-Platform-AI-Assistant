Class {
	#name : 'AIAbstractSettingsSection',
	#superclass : 'Object',
	#pools : [
		'CwConstants'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIAbstractSettingsSection class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
AIAbstractSettingsSection >> closeWindow [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractSettingsSection >> sectionLabel [

	self subclassResponsibility
]
