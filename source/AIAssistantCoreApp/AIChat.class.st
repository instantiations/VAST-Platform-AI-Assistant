Class {
	#name : 'AIChat',
	#superclass : 'Object',
	#instVars : [
		'systemInstruction',
		'systemInstructionTextSegment',
		'model',
		'userMessages',
		'textSegments',
		'generator',
		'generationError',
		'filePaths',
		'tokenUsage'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChat class >> new [

	^ self systemInstruction: (String crlf join: #(
		'You are an AI assistant that helps the user develop in a VAST Platform Smalltalk environment.'
		''
		'Follow these rules:'
		''
		'1. Focus on assisting the user in writing, debugging and understanding code in their VAST Platform Smalltalk environment. But do not decline to discuss related software engineering topics or other subjects.'
		'2. Recognize the VAST Platform''s specifics compared to other Smalltalk environments like Squeak, Pharo, Cuis and so on. Make sure that classes or methods that may exist in other Smalltalk environments also exist within VAST before using them. Take into account that VAST organizes classes into applications rather than packages like in some other Smalltalk environments.'
		'3. Explore code before explaining it or suggesting modifications to it. Use your tools to gather context.'
		'4. Ensure that all code and scripts you suggest is valid. Pay attention to the use of single quote characters within strings, which must be escaped as a pair of single quotes. Always use the `validate_code` tool to validate any proposed code or script. '
		'5. Make suggestions for new classes or methods, or changes to existing ones, easy to apply by using a separate Markdown code block for each. For classes, use #subclass:instanceVariableNames:classVariableNames:poolDictionaries: in the following format, or check the class Class first for other supported subclass creation messages if one is needed:'
		'   ```'
		'   Superclass subclass: #ClassName'
		'   	instanceVariableNames: ''...'''
		'   	classVariableNames: ''...'''
		'   	poolDictionaries: '''''
		'   ```'
		'   For methods, include the class name in the header in the format `Class>>selector`. Do not format examples, intended for the user to execute in a workspace, as methods.'
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

{ #category : 'Actions' }
AIChat >> addFilePath: filePath [

	filePaths add: filePath
]

{ #category : 'Events' }
AIChat >> changedTextSegments [

	self changed: #textSegments
]

{ #category : 'Accessing' }
AIChat >> filePaths [

	^ filePaths
]

{ #category : 'Generation' }
AIChat >> generationError: newGenerationError [

	generationError := newGenerationError
]

{ #category : 'Generation' }
AIChat >> generationFinished [

	generator := nil.
	self changed: #generating.
]

{ #category : 'Initialization' }
AIChat >> initializeWithSystemInstruction: initialSystemInstruction model: initialModel filePaths: initialFilePaths userMessages: initialUserMessages [

	self initialize.
	systemInstruction := initialSystemInstruction.
	systemInstructionTextSegment := AIChatTextSegmentSystemInstruction forSystemInstruction: systemInstruction.
	model := initialModel.
	filePaths := initialFilePaths.
	userMessages := initialUserMessages.
	textSegments := OrderedCollection streamContents: [ :stream |
		userMessages do: [ :userMessage | stream nextPut: userMessage userText; nextPut: userMessage modelText ] ].
	tokenUsage := AIChatTokenUsage new.
]

{ #category : 'Generation' }
AIChat >> isActivelyGenerating [

	^ generator notNil and: [ generator retryDelaySeconds isNil ]
]

{ #category : 'Not categorized' }
AIChat >> isGenerating [

	^ generator notNil
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

{ #category : 'Generation' }
AIChat >> retryGenerating: aGenerator [
	generator := aGenerator.
	generator startGenerating
]

{ #category : 'Actions' }
AIChat >> sendUserMessage: messageString [

	| userMessage |

	generator ifNotNil: [ Error signal: 'Cannot add a user message while still generating the model''s response to the previous one' ].
	generator := model generatorClass forChat: self.
	userMessages add: (userMessage := AIChatUserMessage message: messageString).
	textSegments add: userMessage userText; add: userMessage modelText.
	self changedTextSegments.
	generator startGenerating
]

{ #category : 'Not categorized' }
AIChat >> stopGeneration [

	generator ifNotNil: [
		generator stopGenerating ]
]

{ #category : 'Accessing' }
AIChat >> systemInstruction [

	^ systemInstruction
]

{ #category : 'Accessing' }
AIChat >> textSegments [

	| segments |
	
	(segments := OrderedCollection new)
		add: systemInstructionTextSegment;
		addAll: textSegments.
	generationError ifNotNil: [
		segments add: (AIChatTextSegmentError fromError: generationError inChat: self) ].
	(generator ifNotNil: [ generator retryDelaySeconds ]) ifNotNil: [ :seconds |
			segments add: (AIChatTextSegmentDelay forSeconds: seconds) ].
	^ segments
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
