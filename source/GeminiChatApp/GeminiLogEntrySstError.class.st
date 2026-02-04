Class {
	#name : 'GeminiLogEntrySstError',
	#superclass : 'GeminiAbstractLogEntry',
	#instVars : [
		'errorCode',
		'errorObject'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiLogEntrySstError class >> timestamp: timestamp model: model requestObject: requestObject errorCode: errorCode errorObject: errorObject [

	^ self basicNew initializeWithTimestamp: timestamp model: model requestObject: requestObject
		errorCode: errorCode errorObject: errorObject
]

{ #category : 'Not categorized' }
GeminiLogEntrySstError >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject errorCode: initialErrorCode errorObject: initialErrorObject [

	self initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject.
	errorCode := initialErrorCode.
	errorObject := initialErrorObject.
]
