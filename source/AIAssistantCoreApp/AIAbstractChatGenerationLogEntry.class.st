Class {
	#name : 'AIAbstractChatGenerationLogEntry',
	#superclass : 'Object',
	#instVars : [
		'timestamp',
		'model',
		'requestObject'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractChatGenerationLogEntry >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject [

	self initialize.
	timestamp := initialTimestamp.
	model := initialModel.
	requestObject := initialRequestObject.
]
