Class {
	#name : 'AIChatGenerationLogEntryAPIError',
	#superclass : 'AIAbstractChatGenerationLogEntry',
	#instVars : [
		'responseHeader',
		'responseErrorObject'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGenerationLogEntryAPIError class >> timestamp: timestamp model: model requestObject: requestObject responseHeader: responseHeader responseErrorObject: responseErrorObject [

	^ self basicNew initializeWithTimestamp: timestamp model: model requestObject: requestObject
		responseHeader: responseHeader responseErrorObject: responseErrorObject
]

{ #category : 'Not categorized' }
AIChatGenerationLogEntryAPIError >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject responseHeader: initialResponseHeader responseErrorObject: initialResponseErrorObject [

	self initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject.
	responseHeader := initialResponseHeader.
	responseErrorObject := initialResponseErrorObject.
]
