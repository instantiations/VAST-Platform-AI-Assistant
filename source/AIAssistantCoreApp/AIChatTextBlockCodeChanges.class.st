Class {
	#name : 'AIChatTextBlockCodeChanges',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'changes',
		'textElement'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextBlockCodeChanges class >> changes: aCollectionOfChanges [
	^ self basicNew initializeWithChanges: aCollectionOfChanges
]

{ #category : 'Accessing' }
AIChatTextBlockCodeChanges >> changes [
	^ changes
]

{ #category : 'Initialization' }
AIChatTextBlockCodeChanges >> initializeWithChanges: aCollectionOfChanges [
	self initialize.
	changes := aCollectionOfChanges
]

{ #category : 'Testing' }
AIChatTextBlockCodeChanges >> isCodeChangesBlock [

	^ true
]
