Class {
	#name : 'AIFunctionCallArgumentsJSONObject',
	#superclass : 'AIAbstractFunctionCallArguments',
	#instVars : [
		'jsonObject'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIFunctionCallArgumentsJSONObject class >> jsonObject: jsonObject [

	^ self basicNew initializeWithJSONObject: jsonObject
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIFunctionCallArgumentsJSONObject >> initializeWithJSONObject: initialJSONObject [

	self initialize.
	jsonObject := initialJSONObject.
]

{ #category : 'Accessing' }
AIFunctionCallArgumentsJSONObject >> jsonObject [

	^ jsonObject
]

{ #category : 'Storing' }
AIFunctionCallArgumentsJSONObject >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' jsonObject: '.
	jsonObject storeOn: stream.
	stream nextPut: $).
]
