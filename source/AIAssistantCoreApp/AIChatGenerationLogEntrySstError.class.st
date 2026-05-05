Class {
	#name : 'AIChatGenerationLogEntrySstError',
	#superclass : 'AIAbstractChatGenerationLogEntry',
	#instVars : [
		'errorCode',
		'errorObject'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGenerationLogEntrySstError class >> timestamp: timestamp model: model requestObject: requestObject errorCode: errorCode errorObject: errorObject [

	^ self basicNew initializeWithTimestamp: timestamp model: model requestObject: requestObject
		errorCode: errorCode errorObject: errorObject
]

{ #category : 'Not categorized' }
AIChatGenerationLogEntrySstError >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject errorCode: initialErrorCode errorObject: initialErrorObject [

	self initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject.
	errorCode := initialErrorCode.
	errorObject := initialErrorObject.
]
