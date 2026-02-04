Class {
	#name : 'GeminiLogEntryAPIError',
	#superclass : 'GeminiAbstractLogEntry',
	#instVars : [
		'responseHeader',
		'responseErrorObject'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiLogEntryAPIError class >> timestamp: timestamp model: model requestObject: requestObject responseHeader: responseHeader responseErrorObject: responseErrorObject [

	^ self basicNew initializeWithTimestamp: timestamp model: model requestObject: requestObject
		responseHeader: responseHeader responseErrorObject: responseErrorObject
]

{ #category : 'Not categorized' }
GeminiLogEntryAPIError >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject responseHeader: initialResponseHeader responseErrorObject: initialResponseErrorObject [

	self initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject.
	responseHeader := initialResponseHeader.
	responseErrorObject := initialResponseErrorObject.
]
