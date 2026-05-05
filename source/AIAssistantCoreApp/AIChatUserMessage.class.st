Class {
	#name : 'AIChatUserMessage',
	#superclass : 'Object',
	#instVars : [
		'message',
		'generatedContents'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatUserMessage class >> message: message [

	^ self message: message generatedContents: OrderedCollection new
]

{ #category : 'Not categorized' }
AIChatUserMessage class >> message: message generatedContents: generatedContents [

	^ self basicNew initializeWithMessage: message generatedContents: generatedContents
]

{ #category : 'Not categorized' }
AIChatUserMessage >> addNewGeneratedContent [

	generatedContents add: AIChatGeneratedContent new
]

{ #category : 'Not categorized' }
AIChatUserMessage >> applyFunctionsInLastGeneratedContentUsing: functionsSet inContext: functionCallContext [

	(generatedContents ifEmpty: [ ^ false ]) last addFunctionResponseParts:
		((generatedContents last functionCallParts ifEmpty: [ ^ false ])
			collect: [ :part | functionsSet applyFunctionCall: part in: functionCallContext ]).
	^ true
]

{ #category : 'Not categorized' }
AIChatUserMessage >> generatedContents [

	^ generatedContents
]

{ #category : 'Not categorized' }
AIChatUserMessage >> initializeWithMessage: initialMessage generatedContents: initialGeneratedContents [

	super initialize.
	message := initialMessage.
	generatedContents := initialGeneratedContents.
]

{ #category : 'Not categorized' }
AIChatUserMessage >> message [

	^ message
]

{ #category : 'Not categorized' }
AIChatUserMessage >> modelText [

	| rootBlock rootOrThoughtBlock pendingTextPartStrings functionCallsBlock |
	
	rootBlock := AIChatTextBlockSequence new.
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
						rootOrThoughtBlock addBlock: (AIChatTextBlockSequence fromString: ('' join: pendingTextPartStrings)) ].
					pendingTextPartStrings := OrderedCollection with: part string.
					rootOrThoughtBlock := part isThought
						ifTrue: [
							| thoughtBlock |
							thoughtBlock := AIChatTextBlockThought new.
							rootBlock addBlock: thoughtBlock.
							thoughtBlock ]
						ifFalse: [ rootBlock ].
					functionCallsBlock := nil ] ].
			part isFunctionCall ifTrue: [
				functionCallsBlock ifNotNil: [
					functionCallsBlock addFunctionCall: part
				] ifNil: [
					pendingTextPartStrings ifNotEmpty: [
						rootOrThoughtBlock addBlock: (AIChatTextBlockSequence fromString: ('' join: pendingTextPartStrings)).
						pendingTextPartStrings := OrderedCollection new ].
					part thoughtSignature notNil ~= rootOrThoughtBlock isThoughtBlock ifTrue: [
						rootOrThoughtBlock := part thoughtSignature
							ifNotNil: [
								| thoughtBlock |
								thoughtBlock := AIChatTextBlockThought new.
								rootBlock addBlock: thoughtBlock.
								thoughtBlock ]
							ifNil: [ rootBlock ] ].
					(functionCallsBlock := AIChatTextBlockFunctionCalls new)
						addFunctionCall: part.
					rootOrThoughtBlock addBlock: functionCallsBlock ] ] ] ].
	pendingTextPartStrings ifNotEmpty: [
		rootOrThoughtBlock addBlock: (AIChatTextBlockSequence fromString: ('' join: pendingTextPartStrings)) ].
	^ AIChatTextSegmentModelMessage textBlocks: rootBlock blocks
]

{ #category : 'Not categorized' }
AIChatUserMessage >> userContentJSON [

	^ EsOrderedDictionary with: 'role' -> 'user'
		with: 'parts' -> { EsOrderedDictionary with: 'text' -> message }
]

{ #category : 'Not categorized' }
AIChatUserMessage >> userText [

	^ AIChatTextSegmentUserMessage textBlocks: (AIChatTextBlockSequence fromString: message) blocks
]
