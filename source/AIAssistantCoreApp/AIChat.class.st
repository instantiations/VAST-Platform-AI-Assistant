Class {
	#name : 'AIChat',
	#superclass : 'Object',
	#instVars : [
		'systemInstruction',
		'systemInstructionTextSegment',
		'model',
		'userMessages',
		'textSegments',
		'functionCallPermissionTextSegments',
		'generator',
		'generationError',
		'generationErrorTextSegment',
		'filePaths',
		'tokenUsage',
		'title'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChat class >> new [

	^ self systemInstruction: (CldtConstants::LineDelimiter join: #(
		'You are an AI assistant that helps the user develop in a VAST Platform Smalltalk environment.'
		''
		'Follow these rules:'
		''
		'1. Focus on assisting the user in writing, debugging and understanding code in their VAST Platform Smalltalk environment. But do not decline to discuss related software engineering topics or other subjects.'
		'2. Recognize the VAST Platform''s specifics compared to other Smalltalk environments like Squeak, Pharo, Cuis and so on. Make sure that classes or methods that may exist in other Smalltalk environments also exist within VAST before using them. Take into account that VAST organizes classes into applications rather than packages like in some other Smalltalk environments.'
		'3. Explore code before explaining it or suggesting modifications to it. Use your tools to gather context.'
		'4. Ensure that all code and scripts you suggest is valid. Pay attention to the use of single quote characters within strings, which must be escaped as a pair of single quotes. Always use the `validate_code` tool to validate any proposed code or script. '
		'5. When suggesting new classes or methods, or modifications to existing ones, use the provided modification tools (add_class, add_method, change_class, change_method, remove_class, remove_method) instead of outputting them as Markdown code blocks.'
		'    Important details on using modification tools:'
		'    - These tools do not modify the live image immediately; instead, they generate proposed changes in the user''s VAST environment for them to review and apply.'
		'    - The generated code will be automatically displayed to the user in a code block by the system. Do not output the code in your text response. Instead, provide any explanation of the generated code in your text response.'
		'    - Do not attempt to query or reflect on a class or method immediately after using a modification tool to create/change it, as the changes will not exist in the environment until the user manually approves them.'
		'   Only use Markdown code blocks for code examples or workspace scripts meant for the user to execute manually.'
		'6. Getting source code in VAST may be slow. When using the parameter `with_source` available in many tools, try to minimize cases where a `true` is specified and try favor `false`'
		))
]

{ #category : 'Not categorized' }
AIChat class >> systemInstruction: systemInstruction [

	^ self systemInstruction: systemInstruction model: AIAbstractModel default
]

{ #category : 'Not categorized' }
AIChat class >> systemInstruction: systemInstruction model: model [

	^ self systemInstruction: systemInstruction model: model userMessages: OrderedCollection new
]

{ #category : 'Not categorized' }
AIChat class >> systemInstruction: systemInstruction model: model filePaths: filePaths userMessages: userMessages [

	^ self basicNew initializeWithSystemInstruction: systemInstruction model: model filePaths: filePaths userMessages: userMessages
]

{ #category : 'Not categorized' }
AIChat class >> systemInstruction: systemInstruction model: model userMessages: userMessages [

	^ self systemInstruction: systemInstruction model: model filePaths: OrderedCollection new userMessages: userMessages
]

{ #category : 'Generation' }
AIChat >> addCodeChangesTextSegment [

	userMessages last codeChangesText ifNotNil: [ :codeChangesTextSegment |
		textSegments add: codeChangesTextSegment.
		self changedTextSegments ].
]

{ #category : 'Actions' }
AIChat >> addFilePath: filePath [

	filePaths add: filePath
]

{ #category : 'Events' }
AIChat >> changedTextSegments [

	self changed: #textSegments
]

{ #category : 'Not categorized' }
AIChat >> debugGenerationError [

	self generationError: nil.
	generator generationErrorHandler: #debug.
	self generationFinished.
]

{ #category : 'Accessing' }
AIChat >> filePaths [

	^ filePaths
]

{ #category : 'Not categorized' }
AIChat >> functionCallPermissionTextSegments: newFunctionCallPermissionTextSegments [

	functionCallPermissionTextSegments := newFunctionCallPermissionTextSegments.
	self changedTextSegments.
]

{ #category : 'Generation' }
AIChat >> generateTitleInBackground [
	| summarizerChat firstMessage prompt summarizerGenerator userMessage |
	firstMessage := userMessages first message.
	prompt := 'Extract the core subject from the user''s message and return it as a short 3-5 word title.
Examples:
User: Can you explain how Smalltalk image saving works?
Title: Smalltalk Image Saving

User: How do I loop over a collection in VAST?
Title: Looping Over Collections

Return ONLY the Title text. No preambles, no quotes, no markdown.'.

	userMessage := AIChatUserMessage message: firstMessage.
	summarizerChat := self class
		systemInstruction: prompt
		model: self model
		userMessages: (OrderedCollection with: userMessage).
	summarizerChat title: 'summarizer'.
		
	[
		summarizerGenerator := self model generatorClass forChat: summarizerChat.
		[
			summarizerGenerator generate.
			summarizerChat userMessages first generatedContents isEmpty not ifTrue: [
				| generatedText generatedParts |
				generatedParts := summarizerChat userMessages first generatedContents last modelContentParts.
				generatedText := '' join: ((generatedParts select: [ :part | part isText and: [ part isThought not ] ]) collect: [ :part | part string ]).
				generatedText ifNotEmpty: [
					generatedText := generatedText copyReplaceAll: 'Title: ' with: ''.
					title := generatedText trimBlanks.
					CwAppContext default syncExecInUI: [ self changed: #title ] ].
			].
		] on: Error do: [ :error | "Ignore background generation errors" error return: nil ].
	] fork.
]

{ #category : 'Accessing' }
AIChat >> generationError [

	^generationError
]

{ #category : 'Generation' }
AIChat >> generationError: newGenerationError [

	generationError := newGenerationError.
	generationErrorTextSegment := generationError ifNotNil: [
		generationErrorTextSegment := (AIChatTextSegmentError forError: generationError
			onRetry: [ self retryGeneration ] onInspect: [ generationError inspect ] onDebug: [ self debugGenerationError ]) ].
	self changedTextSegments.
	self changed: #generating.
]

{ #category : 'Generation' }
AIChat >> generationFinished [

	generator := nil.
	self changed: #generating.
]

{ #category : 'Initialization' }
AIChat >> initializeWithSystemInstruction: initialSystemInstruction
	model: initialModel
	filePaths: initialFilePaths
	userMessages: initialUserMessages [

	self initialize.
	systemInstruction := initialSystemInstruction.
	systemInstructionTextSegment := AIChatTextSegmentSystemInstruction forSystemInstruction: systemInstruction.
	model := initialModel.
	filePaths := initialFilePaths.
	userMessages := initialUserMessages.
	textSegments :=
		OrderedCollection streamContents: [:stream |
			userMessages do: [:userMessage |
				stream
					nextPut: userMessage userText;
					nextPut: userMessage modelText.
				userMessage codeChangesText
					ifNotNil: [:codeChangesText | stream nextPut: codeChangesText]]].
	functionCallPermissionTextSegments := OrderedCollection new.
	tokenUsage := AIChatTokenUsage new
]

{ #category : 'Generation' }
AIChat >> isActivelyGenerating [

	^ generator notNil and: [ functionCallPermissionTextSegments isEmpty and: [ generator retryDelaySeconds isNil and: [ generationError isNil ] ] ]
]

{ #category : 'Not categorized' }
AIChat >> isGenerating [

	^ generator notNil and: [ generationError isNil ]
]

{ #category : 'Not categorized' }
AIChat >> isStoppingGeneration [

	^ generator notNil and: [ generator isStopping ]
]

{ #category : 'Accessing' }
AIChat >> model [

	^ model
]

{ #category : 'Accessing' }
AIChat >> model: newModel [

	model := newModel
]

{ #category : 'Not categorized' }
AIChat >> removeFunctionCallPermissionTextSegment: functionCallPermissionTextSegment [

	functionCallPermissionTextSegments remove: functionCallPermissionTextSegment.
	self changedTextSegments.
	functionCallPermissionTextSegments ifEmpty: [
		generator functionCallPermissionsSet ]
]

{ #category : 'Not categorized' }
AIChat >> retryGeneration [

	self generationError: nil.
	generator generationErrorHandler: #retry.
]

{ #category : 'Actions' }
AIChat >> sendUserMessage: messageString [

	| userMessage |

	generator ifNotNil: [
		generationError ifNil: [
			Error signal: 'Cannot add a user message while still generating the model''s response to the previous one' ].
		self generationError: nil.
		generator generationErrorHandler: #exit ].
	generator := model generatorClass forChat: self.
	userMessages add: (userMessage := AIChatUserMessage message: messageString).
	textSegments add: userMessage userText; add: userMessage modelText.
	self changedTextSegments.
	generator startGenerating.
	
	(userMessages size = 1 and: [ title isNil ]) ifTrue: [ self generateTitleInBackground ]
]

{ #category : 'Not categorized' }
AIChat >> stopGeneration [

	generator ifNotNil: [
		generator stopGenerating.
		functionCallPermissionTextSegments ifNotEmpty: [
			self functionCallPermissionTextSegments: OrderedCollection new.
			generator functionCallPermissionsSet ] ]
]

{ #category : 'Accessing' }
AIChat >> systemInstruction [

	^ systemInstruction
]

{ #category : 'Not categorized' }
AIChat >> terminateGeneration [

	self stopGeneration.
	generator ifNotNil: [
		generator generationErrorHandler: #exit ]
]

{ #category : 'Accessing' }
AIChat >> textSegments [

	| segments |
	
	(segments := OrderedCollection new)
		add: systemInstructionTextSegment;
		addAll: textSegments;
		addAll: functionCallPermissionTextSegments.
	generationErrorTextSegment ifNotNil: [
		segments add: generationErrorTextSegment ].
	(generator ifNotNil: [ generator retryDelaySeconds ]) ifNotNil: [ :seconds |
			segments add: (AIChatTextSegmentDelay forSeconds: seconds) ].
	^ segments
]

{ #category : 'Accessing' }
AIChat >> title [
	^ title
]

{ #category : 'Accessing' }
AIChat >> title: aString [
	title := aString.
	self changed: #title
]

{ #category : 'Accessing' }
AIChat >> tokenUsage [

	^ tokenUsage
]

{ #category : 'Accessing' }
AIChat >> tokenUsage: newTokenUsage [

	tokenUsage := newTokenUsage
]

{ #category : 'Generation' }
AIChat >> updateLastModelTextSegment [

	| removed |

	removed := textSegments removeLast.
	textSegments add: userMessages last modelText.
	textSegments last copyStateFrom: removed.
	self changedTextSegments
]

{ #category : 'Accessing' }
AIChat >> userMessages [

	^ userMessages
]
