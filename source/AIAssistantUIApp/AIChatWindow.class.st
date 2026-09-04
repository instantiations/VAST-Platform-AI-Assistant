Class {
	#name : 'AIChatWindow',
	#superclass : 'EtWindow',
	#instVars : [
		'filePathString',
		'chat',
		'chatWidget',
		'buttonWidget',
		'statusLine',
		'inputWidget'
	],
	#pools : [
		'CwConstants'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Instance Creation' }
AIChatWindow class >> chat: chat [

	^ self filePathString: nil chat: chat
]

{ #category : 'ET-Internal' }
AIChatWindow class >> desiredWindowSize [
	"Answer the desired window size."

	^self windowRatio * (700 @ 600)
]

{ #category : 'ET-Internal',
  #vaVisibility : 'private' }
AIChatWindow class >> fileNameFromPathString: aString [

	| theFileNameAndExtension indexOfExtension |

	theFileNameAndExtension := aString abrSimpleFilename.
	indexOfExtension := theFileNameAndExtension lastIndexOf: $..
	^indexOfExtension > 0
		ifTrue: [theFileNameAndExtension copyFrom: 1 to: (indexOfExtension - 1)]
		ifFalse: [theFileNameAndExtension]
]

{ #category : 'Instance Creation' }
AIChatWindow class >> filePathString: filePathString chat: chat [

	^ self basicNew initializeWithFilePathString: filePathString chat: chat; yourself
]

{ #category : 'Instance Creation' }
AIChatWindow class >> fromFile: pathString [

	| fileStream chat |

	fileStream := CfsReadFileStream open: pathString.
	^ [ 
		chat := Compiler evaluate: fileStream contents.
		(chat isKindOf: CompilerError) ifTrue: [
			(CwMessagePrompter confirm: 'A compiler error occurred while reading the file. Would you like to open a workspace to investigate the issue?') ifTrue: [
				| ws |
				ws := StsWorkspace new.
				ws label: 'Compiler Error in ' , pathString.
				ws open.
				ws textWidget setString: fileStream contents.
				ws compilerError: chat
			].
			^ nil ].
		chat title: (self fileNameFromPathString: pathString).
		self filePathString: pathString chat: chat
	] ensure: [ fileStream close ]
]

{ #category : 'Instance Creation' }
AIChatWindow class >> new [

	^ self chat: AIChat new
]

{ #category : 'Operations' }
AIChatWindow >> acceptNewUserMessage: aString [
	"Send aString as a user message in the chat of this window. 
	 Return true if the user message can be sent, false when the chat is busy generating."

	chat isGenerating
		ifTrue: [^false]
		ifFalse: [
			self sendUserMessage: aString.
			^true]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatWindow >> asValidWindowsFileName: aString [
	"Answer a copy of the receiver with any invalid charcters for Windows or Unix platforms converted to $_ .
	 
	 In addition, since the filesystem interface does not support UnicodeString yet, filter all characters beyond codepoint 256"

	^(aString collect: [:e |
		(e codePoint > 255 or: [CfsNTFSPath isIllegalCharacter: e]) ifTrue: [$_] ifFalse: [e]])
			asReducedString
]

{ #category : 'User Interface' }
AIChatWindow >> chatIsAvailableForUserMessage [
	"Returns true if this is a visible window and has a chat that is not actively generating."
	
	^self shell notNil
		and: [self shell isDestroyed not 
			and: [chat notNil 
				and: [chat isGenerating not]]]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatWindow >> chatTitle [

	^chat ifNotNil: [chat title]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatWindow >> convertSelectionText: w [

	"Ignore"
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> createMenusBeforeWorkRegion [

	self menuBar
		addMenu: self menuChat;
		addMenu: self menuEdit;
		addMenu: self menuOptions;
		addMenu: self menuDebug;
		addMenu: self menuHelp
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> createWorkRegion [

	| sash selectedType unknown notSymbol buttonForm |

	sash := (self newSash: XmHORIZONTAL) manageChild.
	(chatWidget := AIChatWidget createWidget: 'chat' parent: self defaultWidgetParent argBlock: nil)
		manageChild;
		chat: chat;
		menu:
			(CwMenu new
				configureBlock: [
					selectedType := self stsSelectedType.
					unknown := selectedType == ##unknownselector or: [ selectedType == ##unknownglobal ].
					notSymbol := selectedType notNil and: [ selectedType ~~ ##symbol ] ];
				add: #menuEditCopy label: MxEST70 enable: [ self enableCopy ] for: self;
				addLine;
				add: #menuEditExecute label: MxEST72 enable: [ self allowExecution ];
				add: #menuEditInspect label: MxEST37 enable: [ self allowExecution ];
				addLine;
				add: #stsSenders label: [ self stsSendersLabelFor: selectedType ] enable: [ true ] for: self;
				add: #stsImplementors label: [ self stsImplementorsLabelFor: selectedType ] enable: [ notSymbol ] visible: [ unknown not ] for: self;
				yourself)
			owner: self.
	inputWidget :=
		(self defaultWidgetParent
			createScrolledText: 'text'
			argBlock: [:w |
				w
					editMode: XmMULTILINEEDIT;
					wordWrap: true]) manageChild.
	inputWidget
		addEventHandler: KeyPressMask
		receiver: self
		selector: #keyPressedInInputWidget:clientData:callData:
		clientData: nil.
	self addTargetTextWidgetCallbacks: inputWidget.

	(buttonForm := self defaultWidgetParent createForm: nil argBlock: nil)
		manageChild.
	(buttonWidget :=
		buttonForm
			createPushButton: 'button'
			argBlock: [:w |
				w
					labelString: 'Send';
					marginWidth: 10])
		manageChild;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #pushedButton:clientData:callData:
			clientData: nil.
	statusLine := self addOSInformationLine: buttonForm.

	chatWidget setValuesBlock: [:w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: sash].
	sash setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			topAttachment: XmATTACHPOSITION;
			topPosition: 75;
			borderWidth: 0].
	inputWidget parent setValuesBlock: [:w |
		w
			topAttachment: XmATTACHWIDGET;
			topWidget: sash;
			leftAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: statusLine;
			rightAttachment: XmATTACHFORM].
	buttonForm setValuesBlock: [:w |
		w
			topAttachment: XmATTACHOPPOSITEFORM;
			topOffset: statusLine topOffset;
			bottomAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM].
	buttonWidget setValuesBlock: [:w |
		w
			topAttachment: XmATTACHFORM;
			topOffset: 3;
			leftAttachment: XmATTACHFORM;
			leftOffset: 3;
			rightAttachment: XmATTACHFORM;
			rightOffset: 3;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 3;
			marginLeft: 8;
			marginRight: 8].
			
	self updateStatusLine
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIChatWindow >> initializeAfterRealize [

	super initializeAfterRealize.
	self updateInput.
	inputWidget setInputFocus.
]

{ #category : 'ET-Internal',
  #vaVisibility : 'private' }
AIChatWindow >> initializeUndoManagers [
	
	"No undo manager to initialize."
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIChatWindow >> initializeWithFilePathString: initialFilePathString chat: initialChat [

	super initialize.
	filePathString := initialFilePathString.
	chat := initialChat.
	chat addDependent: self.
	AIAbstractModel addDependent: self.
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> keyPressedInInputWidget: widget clientData: clientData callData: callData [

	(callData keysym = XKReturn
		and: [(callData state noMask: ShiftMask) and: [chat isGenerating not]])
			ifTrue: [
				chat model isNil: [
					CwMessagePrompter
						warningMessage: 'Setup provider and add model before sending message'.
					^AISettingsWindow new open].
				self sendUserMessage]
]

{ #category : 'User Interface' }
AIChatWindow >> label [

	| baseLabel |

	baseLabel := 'AI Assistant'.
	self chatTitle ifNotNil: [:chatTitle | baseLabel := baseLabel , ' - ' , chatTitle].
	^baseLabel
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionChatAddFile [

	CwFileSelectionPrompter new prompt
		ifNotNil: [:selectedPathString | chat addFilePath: (CfsPath named: selectedPathString)]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionChatExport [

	(CwFileSelectionPrompter new
		accessType: XmSAVE;
		fileExtension: '.md';
		fileName: (self chatTitle ifNotNil: [ :chatTitle | (self asValidWindowsFileName: chatTitle) , '.md' ] ifNil: [ '' ]);
		prompt) ifNotNil: [ :pathString |
			| formattedString fileStream |
			formattedString := String streamContents: [ :stream | chat writeFormattedOn: stream ].
			fileStream := CfsWriteFileStream openEmpty: pathString.
			[
				fileStream isBytes: true;
					nextPutAll: formattedString asUtf8Bytes
			] ensure: [ fileStream close ] ]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionChatNew [
	"Open new window on same chat class as is used in the current ChatWindow"
	(self class chat: chat class new) open
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionChatOpen [

	(CwFileSelectionPrompter new
			fileExtension: '.gc';
			prompt) ifNotNil: [ :selectedPathString |
				(self class fromFile: selectedPathString) ifNotNil:[:w | w open]].
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionChatSave [

	filePathString ifNil: [ ^ self menuActionChatSaveAs ].
	self saveToFile: filePathString
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionChatSaveAs [

	| prompter |

	prompter :=
		CwFileSelectionPrompter new
			accessType: XmSAVE;
			fileExtension: '.gc'.

	self chatTitle ifNotNil: [:chatTitle | | defaultFileName |
		defaultFileName := (self asValidWindowsFileName: chatTitle) , '.gc'.
		prompter fileName: defaultFileName].

	filePathString := prompter prompt.
	filePathString ifNotNil: [:selectedPathString | self saveToFile: selectedPathString]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionInspectChat [

	self inspect
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionInspectLog [

	AIChatGenerationLog current entries inspect
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionOpenSettings [

	AISettingsWindow new open
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionSelectModel: aModel [

	chat model: aModel.
	AIAbstractModel default: aModel.
	self updateInput
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> menuChat [

	| chatMenu |

	(chatMenu := self newMenu)
		title: 'Chat';
		add: #menuActionChatNew label: 'New' enable: true for: nil;
		add: #menuActionChatOpen label: 'Open...' enable: true for: nil;
		add: #menuActionChatSave label: 'Save' enable: true for: nil;
		add: #menuActionChatSaveAs label: 'Save As...' enable: true for: nil;
		add: #menuActionChatExport label: 'Export...';
		addLine;
		add: #menuActionChatAddFile label: 'Add File...' enable: true for: nil.

	^chatMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> menuDebug [

	| debugMenu |

	(debugMenu := self newMenu)
		title: 'Debug';
		add: #menuActionInspectChat label: 'Inspect Chat' enable: true for: nil;
		add: #menuActionInspectLog label: 'Inspect Log' enable: true for: nil.
	^debugMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> menuEdit [

	editMenu notNil ifTrue: [^editMenu].
	(editMenu := self newMenu)
		title: 'Edit';
		add: #menuEditCopy
			label: MxEST70
			enable: [ self enableCopy ]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask keysym: XKc)
			acceleratorText: MxEST84;
		addLine;
		add: #menuEditExecute
			label: MxEST72	
			enable: [ self allowExecution ]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask keysym: XKe)
			acceleratorText: MxEST86;
		add: #menuEditInspect
			label: MxEST37
			enable: [ self allowExecution ]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask keysym: XKq)
			acceleratorText: MxEST88;
		addLine;
		add: #stsClassReferencesFromTextWidget
			label: 'Browse References'
			enable: [true]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask | ShiftMask keysym: XKr)
			acceleratorText: 'Ctrl+Shift+R';
		add: #stsClassHierarchyFromTextWidget
			label: 'Browse Hierarchy'
			enable: [true]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask | ShiftMask keysym: XKh)
			acceleratorText: 'Ctrl+Shift+H';
		add: #stsAllImplementors
			label: 'Browse All Implementors'
			enable: [true]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask | ShiftMask keysym: XKm)
			acceleratorText: 'Ctrl+Shift+M';
		add: #stsAllSenders
			label: 'Browse All Senders'
			enable: [true]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask | ShiftMask keysym: XKn)
			acceleratorText: 'Ctrl+Shift+N';
		add: #stsMethodsIncludingString
			label: 'Browse Methods Including String'
			enable: [true]
			for: nil
			accelerator: (CwAccelerator mask: ControlMask | ShiftMask keysym: XKf)
			acceleratorText: 'Ctrl+Shift+F'.
	^editMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> menuHelp [

	| helpMenu |

	(helpMenu := self newMenu)
		title: 'Help';
		add: #openDocumentation label: 'Documentation' enable: false for: nil;
		add: #openAboutDialog label: 'About...' enable: true for: nil.
	^helpMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> menuModelOptions [

	| modelOptionsMenu|

	(modelOptionsMenu := self newMenu)
		title: 'Model';
		subMenuSelector: #menuModelOptions;
		owner: self.
	
	AIAbstractModel registeredModels do: [:model |
		modelOptionsMenu
			add: (DirectedMessage selector: #menuActionSelectModel: arguments: { model } receiver: self)
			label: model label
			toggle: [model = chat model]].

	^modelOptionsMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> menuOptions [

	| menu |

	(menu := self newMenu)
		title: 'Options'.
	AIAbstractModel registeredModels isEmpty
		ifFalse: [
			menu
				addSubMenu: #menuModelOptions label: 'Model' enable: true for: self;
				addLine].
	menu add: #menuActionOpenSettings label: 'Settings...' enable: true for: self.
	^menu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> openAboutDialog [

	CwMessagePrompter
		message: 'VAST AI Assistant', String cr,
				 'A Smalltalk Code Assistant using Large Language Models for the VAST Platform.', String cr, String cr,
				 'Copyright (c) 2026 Instantiations, Inc.'
		title: 'About VAST AI Assistant'
		iconType: XmICONINFO
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> pushedButton: button clientData: clientData callData: callData [

	chat isGenerating ifFalse: [
		self sendUserMessage
	] ifTrue: [
		chat stopGeneration.
		self updateInput ]
]

{ #category : 'Events' }
AIChatWindow >> registeredModelsChanged [

	self updateMenuModelOptions.
	self updateStatusLine.
	"update the model used by chat to reflect change"
	(AIAbstractModel registeredModels contains: [:one | one = chat model])
		ifFalse: [chat model: nil].
	(chat model isNil and: [AIAbstractModel registeredModels size = 1])
		ifTrue: [chat model: AIAbstractModel registeredModels first].
]

{ #category : 'Initialization' }
AIChatWindow >> restartWindowFromSnapshot: widgetHierarchySnapshot [

	chatWidget ifNotNil: [
		chatWidget release.
		chatWidget := nil ].
		
	^ super restartWindowFromSnapshot: widgetHierarchySnapshot
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> saveToFile: pathString [

	| fileStream |

	fileStream := CfsWriteFileStream openEmpty: pathString.
	[
		chat storeOn: fileStream.
		filePathString := pathString
	] ensure: [ fileStream close ]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> sendUserMessage [

	inputWidget value ifNotEmpty: [
		self sendUserMessage: inputWidget value ].
	inputWidget value: ''.
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatWindow >> sendUserMessage: aString [

	chatWidget scrollToNextUserMessage.
	chat sendUserMessage: aString.
	self updateInput
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatWindow >> snapshotTextWidget [
	"Overridden because the return value of #widgetForTextMenu is not a text widget."

	^nil
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> statusLineText [

	| max |

	chat model isNil ifFalse: [max := chat model contextWindowSize].
	^ '%1 / %2%3'
		bindWith: chat tokenUsage printString
		with: (max ifNil: [ '?' ] ifNotNil: [ max printString ])
		with: (chat model
			ifNil: [ '' ]
			ifNotNil: [ ' %1 %2' bindWith: ((UnicodeString value: 16r2014) asSBString ifNil: [ '-' ]) with: chat model label ])
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AIChatWindow >> update: aParameter [

	aParameter = #textSegments ifTrue: [self updateStatusLine].
	aParameter = #title ifTrue: [self shell notNil ifTrue: [ self updateLabel ] ].
	aParameter = #generating ifTrue: [self updateInput].
	aParameter = #model ifTrue: [self updateInput; updateStatusLine].
	aParameter = #registeredModelsChanged ifTrue: [self registeredModelsChanged].
	super update: aParameter
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> updateInput [

	inputWidget foregroundColor: ( chat isGenerating not ifTrue: [ Color black ] ifFalse: [ Color darkGray ]).
	buttonWidget
		labelString: (chat isGenerating ifTrue: [ chat isStoppingGeneration ifTrue: [ (UnicodeString escaped: 'Stopping\u{2026}') ] ifFalse: [ 'Stop' ] ] ifFalse: [ 'Send' ]);
		setSensitive: (chat model notNil and: [chat isStoppingGeneration not]).
]

{ #category : 'Events' }
AIChatWindow >> updateMenuModelOptions [
	"Update modelOptions menu to reflect change in registered models"

	| options |

	options := menuBar menuAtTitle: 'Options'.
	options
		removeLineAfter: #menuModelOptions;
		remove: #menuModelOptions.
	AIAbstractModel registeredModels isEmpty
		ifFalse: [
			options
				addSubMenu: #menuModelOptions label: 'Model' enable: true for: self before: #menuActionOpenSettings;
				addLineAfter: #menuModelOptions].
	menuBar recreate.
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> updateStatusLine [

	"Private - Update the status line."

	^ statusLine labelString: ' ' , self statusLineText
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatWindow >> widgetForTextMenu [

	^ chatWidget ifNotNil: [ AIChatWidgetTargetTextWidgetAdapter for: chatWidget ]
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIChatWindow >> windowClose: widget clientData: clientData callData: callData [

	super windowClose: widget clientData: clientData callData: callData.
	AIAbstractModel removeDependent: self.
	callData doit & chat notNil ifTrue: [
		chat removeDependent: self;
			terminateGeneration ].
]
