Class {
	#name : 'AIChatGenerationLogEntryGeneratedContent',
	#superclass : 'AIAbstractChatGenerationLogEntry',
	#instVars : [
		'responseHeader',
		'responseObjects'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGenerationLogEntryGeneratedContent class >> timestamp: timestamp model: model requestObject: requestObject responseHeader: responseHeader responseObjects: responseObjects [

	^ self basicNew initializeWithTimestamp: timestamp model: model requestObject: requestObject
		responseHeader: responseHeader responseObjects: responseObjects
]

{ #category : 'Not categorized' }
AIChatGenerationLogEntryGeneratedContent >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject responseHeader: initialResponseHeader responseObjects: initialResponseObjects [

	self initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject.
	responseHeader := initialResponseHeader.
	responseObjects := initialResponseObjects.
]
