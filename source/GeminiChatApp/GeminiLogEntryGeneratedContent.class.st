Class {
	#name : 'GeminiLogEntryGeneratedContent',
	#superclass : 'GeminiAbstractLogEntry',
	#instVars : [
		'responseHeader',
		'responseObjects'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiLogEntryGeneratedContent class >> timestamp: timestamp model: model requestObject: requestObject responseHeader: responseHeader responseObjects: responseObjects [

	^ self basicNew initializeWithTimestamp: timestamp model: model requestObject: requestObject
		responseHeader: responseHeader responseObjects: responseObjects
]

{ #category : 'Not categorized' }
GeminiLogEntryGeneratedContent >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject responseHeader: initialResponseHeader responseObjects: initialResponseObjects [

	self initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject.
	responseHeader := initialResponseHeader.
	responseObjects := initialResponseObjects.
]
