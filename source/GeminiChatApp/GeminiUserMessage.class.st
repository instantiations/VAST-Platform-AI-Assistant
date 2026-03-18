Class {
	#name : 'GeminiUserMessage',
	#superclass : 'Object',
	#instVars : [
		'message',
		'generatedContents'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiUserMessage class >> message: message [

	^ self message: message generatedContents: OrderedCollection new
]

{ #category : 'Not categorized' }
GeminiUserMessage class >> message: message generatedContents: generatedContents [

	^ self basicNew initializeWithMessage: message generatedContents: generatedContents
]

{ #category : 'Not categorized' }
GeminiUserMessage >> addModelContentPartsToLastGeneratedContent: contentParts [

	generatedContents last addModelContentParts: contentParts
]

{ #category : 'Not categorized' }
GeminiUserMessage >> addNewGeneratedContent [

	generatedContents add: GeminiGeneratedContent new
]

{ #category : 'Not categorized' }
GeminiUserMessage >> applyFunctionsInLastGeneratedContentUsing: functionsSet inContext: functionCallContext [

	generatedContents last addFunctionResponseParts:
		((generatedContents last functionCallParts ifEmpty: [ ^ false ])
			collect: [ :part | functionsSet applyFunctionCall: part in: functionCallContext ]).
	^ true
]

{ #category : 'Not categorized' }
GeminiUserMessage >> generatedContents [

	^ generatedContents
]

{ #category : 'Not categorized' }
GeminiUserMessage >> initializeWithMessage: initialMessage generatedContents: initialGeneratedContents [

	super initialize.
	message := initialMessage.
	generatedContents := initialGeneratedContents.
]

{ #category : 'Not categorized' }
GeminiUserMessage >> message [

	^ message
]

{ #category : 'Not categorized' }
GeminiUserMessage >> modelText [

	| rootBlock rootOrThoughtBlock pendingTextPartStrings functionCallsBlock |
	
	rootBlock := GeminiTextBlockSequence new.
	rootOrThoughtBlock := rootBlock.
	pendingTextPartStrings := OrderedCollection new.
	functionCallsBlock := nil.
	self generatedContents do: [ :generatedContent |
		generatedContent modelContentParts do: [ :part |
			(part isText and: [ part string notEmpty ]) ifTrue: [
				part isThought = rootOrThoughtBlock isThoughtBlock ifTrue: [
					functionCallsBlock ifNil: [
						pendingTextPartStrings add: part string.
					] ifNotNil: [
						functionCallsBlock := nil.
						pendingTextPartStrings := OrderedCollection with: part string ]
				] ifFalse: [
					pendingTextPartStrings ifNotEmpty: [
						rootOrThoughtBlock addBlock: (GeminiTextBlockSequence fromString: ('' join: pendingTextPartStrings)) ].
					pendingTextPartStrings := OrderedCollection with: part string.
					rootOrThoughtBlock := part isThought
						ifTrue: [
							| thoughtBlock |
							thoughtBlock := GeminiTextBlockThought new.
							rootBlock addBlock: thoughtBlock.
							thoughtBlock ]
						ifFalse: [ rootBlock ].
					functionCallsBlock := nil ] ].
			part isFunctionCall ifTrue: [
				functionCallsBlock ifNotNil: [
					functionCallsBlock addFunctionCall: part
				] ifNil: [
					pendingTextPartStrings ifNotEmpty: [
						rootOrThoughtBlock addBlock: (GeminiTextBlockSequence fromString: ('' join: pendingTextPartStrings)).
						pendingTextPartStrings := OrderedCollection new ].
					part thoughtSignature notNil ~= rootOrThoughtBlock isThoughtBlock ifTrue: [
						rootOrThoughtBlock := part thoughtSignature
							ifNotNil: [
								| thoughtBlock |
								thoughtBlock := GeminiTextBlockThought new.
								rootBlock addBlock: thoughtBlock.
								thoughtBlock ]
							ifNil: [ rootBlock ] ].
					(functionCallsBlock := GeminiTextBlockFunctionCalls new)
						addFunctionCall: part.
					rootOrThoughtBlock addBlock: functionCallsBlock ] ] ] ].
	pendingTextPartStrings ifNotEmpty: [
		rootOrThoughtBlock addBlock: (GeminiTextBlockSequence fromString: ('' join: pendingTextPartStrings)) ].
	^ GeminiTextSegmentModelMessage textBlocks: rootBlock blocks
]

{ #category : 'Not categorized' }
GeminiUserMessage >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' message: '.
	message storeOn: stream.
	stream nextPutAll: ' generatedContents: '.
	generatedContents storeOn: stream.
	stream nextPut: $).
]

{ #category : 'Not categorized' }
GeminiUserMessage >> userContentJSON [

	^ EsOrderedDictionary with: 'role' -> 'user'
		with: 'parts' -> { EsOrderedDictionary with: 'text' -> message }
]

{ #category : 'Not categorized' }
GeminiUserMessage >> userText [

	^ GeminiTextSegmentUserMessage textBlocks: (GeminiTextBlockSequence fromString: message) blocks
]
