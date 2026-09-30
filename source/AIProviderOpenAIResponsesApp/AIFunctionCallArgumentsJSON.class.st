Class {
	#name : 'AIFunctionCallArgumentsJSON',
	#superclass : 'AIAbstractFunctionCallArguments',
	#instVars : [
		'json',
		'jsonObjectCache'
	],
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Instantiation' }
AIFunctionCallArgumentsJSON class >> json: json [

	^ self basicNew initializeWithJSON: json
]

{ #category : 'Displaying' }
AIFunctionCallArgumentsJSON >> displayString [

	^ jsonObjectCache
		ifNil: [ 'Invalid arguments JSON: %1' bindWith: json ]
		ifNotNil: [ super displayString ]
]

{ #category : 'Initialization' }
AIFunctionCallArgumentsJSON >> initializeWithJSON: initialJSON [

	self initialize.
	json := initialJSON.
	jsonObjectCache := [
		| jsonValue |
		jsonValue := (AIJSONReader on: (AIPeekableStream on: (AICharacterGraphemeStream on: initialJSON unicodeScalars))) mapClass: EsOrderedDictionary; next.
		jsonValue class = EsOrderedDictionary ifTrue: [ jsonValue ] ]
			when: NeoJSONParseError do: [ :signal |
				signal exitWith: nil ].
]

{ #category : 'Accessing' }
AIFunctionCallArgumentsJSON >> json [

	^ json
]

{ #category : 'Accessing' }
AIFunctionCallArgumentsJSON >> jsonObject [

	^ jsonObjectCache
]

{ #category : 'Storing' }
AIFunctionCallArgumentsJSON >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' json: '.
	json storeOn: stream.
	stream nextPut: $).
]
