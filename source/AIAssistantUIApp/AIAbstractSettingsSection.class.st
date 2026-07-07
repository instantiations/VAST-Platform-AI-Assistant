Class {
	#name : 'AIAbstractSettingsSection',
	#superclass : 'Object',
	#instVars : [
		'widgetsNoCallbacks'
	],
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

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractSettingsSection >> createSettingsPane: settingsForm [

	self subclassResponsibility
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractSettingsSection >> for: widget doCallback: block [

	(widgetsNoCallbacks includes: widget) ifFalse: block
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractSettingsSection >> initialize [

	super initialize.
	widgetsNoCallbacks := Bag new.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractSettingsSection >> noCallback: widget during: block [

	widgetsNoCallbacks add: widget.
	[ block value: widget ]
		ensure: [ widgetsNoCallbacks remove: widget ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractSettingsSection >> sectionChanged [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractSettingsSection >> sectionLabel [

	self subclassResponsibility
]
