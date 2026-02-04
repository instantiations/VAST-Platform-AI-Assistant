Class {
	#name : 'GeminiAbstractLogEntry',
	#superclass : 'Object',
	#instVars : [
		'timestamp',
		'model',
		'requestObject'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractLogEntry >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject [

	self initialize.
	timestamp := initialTimestamp.
	model := initialModel.
	requestObject := initialRequestObject.
]
