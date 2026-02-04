Class {
	#name : 'GeminiChat',
	#superclass : 'Object',
	#instVars : [
		'systemInstruction',
		'systemInstructionTextSegment',
		'model',
		'userMessages',
		'textSegments',
		'textSegmentsMutex',
		'generator',
		'generatorMutex',
		'generationError',
		'filePaths',
		'usageMetadata'
	],
	#classInstVars : [
		'apiKey'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChat class >> apiKey [

	^ apiKey
]

{ #category : 'Not categorized' }
GeminiChat class >> apiKey: newAPIKey [

	apiKey := newAPIKey
]

{ #category : 'Not categorized' }
GeminiChat class >> new [

	^ self systemInstruction: (String crlf join: #(
		'You are an AI assistant that helps the user develop in a VAST Platform Smalltalk image.'
		''
		'Follow these rules:'
		''
		'1. Focus on assisting the user in writing, debugging and understanding code in their VAST Platform Smalltalk image. But do not decline to discuss related software engineering topics or other subjects.'
		'2. Recognize the VAST Platform''s specifics compared to other Smalltalk environments like Squeak, Pharo, Cuis and so on. Make sure that classes or methods that may exist in other Smalltalk environments also exist within VAST before using them. Take into account that VAST organizes classes into applications rather than packages like in some other Smalltalk environments.'
		'3. Explore code before explaining it or suggesting modifications to it. Use your tools to gather context.'
		'4. Ensure that all code you suggest is syntactically valid. Pay attention to the use of single quote characters within strings, which must be escaped as a pair of single quotes. Use the `validate_code` tool if you are unsure or are writing longer snippets.'
		'5. Make suggestions for new classes or methods, or changes to existing ones, easy to apply by using a separate Markdown code block for each. For classes, use #subclass:instanceVariableNames:classVariableNames:poolDictionaries: in the following format, or check the class Class first for other supported subclass creation messages if one is needed:'
		'   ```'
		'   Superclass subclass: #ClassName'
		'   	instanceVariableNames: ''...'''
		'   	classVariableNames: ''...'''
		'   	poolDictionaries: '''''
		'   ```'
		'   For methods, include the class name in the header in the format `Class>>selector`. Do not format examples, intended for the user to execute in a workspace, as methods.'))
]

{ #category : 'Not categorized' }
GeminiChat class >> systemInstruction: systemInstruction [

	^ self systemInstruction: systemInstruction model: GeminiModel default
]

{ #category : 'Not categorized' }
GeminiChat class >> systemInstruction: systemInstruction model: model [

	^ self systemInstruction: systemInstruction model: model userMessages: OrderedCollection new
]

{ #category : 'Not categorized' }
GeminiChat class >> systemInstruction: systemInstruction model: model filePaths: filePaths userMessages: userMessages [

	^ self basicNew initializeWithSystemInstruction: systemInstruction model: model filePaths: filePaths userMessages: userMessages
]

{ #category : 'Not categorized' }
GeminiChat class >> systemInstruction: systemInstruction model: model userMessages: userMessages [

	^ self systemInstruction: systemInstruction model: model filePaths: OrderedCollection new userMessages: userMessages
]

{ #category : 'Not categorized' }
GeminiChat >> addFilePath: filePath [

	filePaths add: filePath
]

{ #category : 'Not categorized' }
GeminiChat >> changedTextSegments [

	self changed: #textSegments
]

{ #category : 'Not categorized' }
GeminiChat >> filePaths [

	^ filePaths
]

{ #category : 'Not categorized' }
GeminiChat >> generationError [

	^ generationError
]

{ #category : 'Not categorized' }
GeminiChat >> generationError: newGenerationError [

	generationError := newGenerationError
]

{ #category : 'Not categorized' }
GeminiChat >> generationFinished [

	generatorMutex critical: [
		generator := nil ].
	self changed: #generating.
]

{ #category : 'Not categorized' }
GeminiChat >> initializeWithSystemInstruction: initialSystemInstruction model: initialModel filePaths: initialFilePaths userMessages: initialUserMessages [

	self initialize.
	systemInstruction := initialSystemInstruction.
	systemInstructionTextSegment := GeminiTextSegmentSystemInstruction forSystemInstruction: systemInstruction.
	model := initialModel.
	filePaths := initialFilePaths.
	userMessages := initialUserMessages.
	textSegments := OrderedCollection streamContents: [ :stream |
		userMessages do: [ :userMessage | stream nextPut: userMessage userText; nextPut: userMessage modelText ] ].
	textSegmentsMutex := Semaphore forMutualExclusion.
	generatorMutex := Semaphore forMutualExclusion.
]

{ #category : 'Not categorized' }
GeminiChat >> isActivelyGenerating [

	^ generatorMutex critical: [
		generator notNil and: [ generator retryDelaySeconds isNil ] ]
]

{ #category : 'Not categorized' }
GeminiChat >> model [

	^ model
]

{ #category : 'Not categorized' }
GeminiChat >> model: newModel [

	model := newModel
]

{ #category : 'Not categorized' }
GeminiChat >> resetTextSegmentHeights [

	textSegmentsMutex critical: [
		textSegments do: [ :textSegment | textSegment resetHeight ] ]
]

{ #category : 'Not categorized' }
GeminiChat >> sendUserMessage: messageString [

	| userMessage |

	generatorMutex critical: [
		generator ifNotNil: [ Error signal: 'Cannot add a user message while still generating the model''s response to the previous one' ].
		generator := GeminiChatGenerator forChat: self ].
	userMessages add: (userMessage := GeminiUserMessage message: messageString).
	textSegmentsMutex critical: [
		textSegments add: userMessage userText; add: userMessage modelText ].
	self changedTextSegments.
	generator startGenerating
]

{ #category : 'Not categorized' }
GeminiChat >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' systemInstruction: '.
	systemInstruction storeOn: stream.
	stream nextPutAll: ' model: ('.
	model class storeOn: stream.
	stream nextPutAll: ' named: '.
	model name storeOn: stream.
	stream nextPutAll: ') filePaths: ('.
	(filePaths collect: [ :filePath | filePath originalName ]) storeOn: stream.
	stream nextPutAll: ' collect: [ :name | CfsPath named: name ])'.
	stream nextPutAll: ' userMessages: '.
	userMessages storeOn: stream.
	stream nextPut: $).
]

{ #category : 'Not categorized' }
GeminiChat >> systemInstruction [

	^ systemInstruction
]

{ #category : 'Not categorized' }
GeminiChat >> textSegments [

	| segments |
	
	segments := OrderedCollection new.
	segments add: systemInstructionTextSegment.
	textSegmentsMutex critical: [
		segments addAll: textSegments ].
	generationError ifNotNil: [
		segments add: (GeminiTextSegmentError fromError: generationError) ].
	(generatorMutex critical: [ generator ifNotNil: [ generator retryDelaySeconds ] ]) ifNotNil: [ :seconds |
			segments add: (GeminiTextSegmentDelay forSeconds: seconds) ].
	^ segments
]

{ #category : 'Not categorized' }
GeminiChat >> updateLastModelTextSegment [

	textSegmentsMutex critical: [
		textSegments removeLast; add: userMessages last modelText ].
	self changedTextSegments.
]

{ #category : 'Not categorized' }
GeminiChat >> usageMetadata [

	^ usageMetadata
]

{ #category : 'Not categorized' }
GeminiChat >> usageMetadata: newUsageMetadata [

	usageMetadata := newUsageMetadata
]

{ #category : 'Not categorized' }
GeminiChat >> userMessages [

	^ userMessages
]
