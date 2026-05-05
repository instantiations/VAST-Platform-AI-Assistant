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

{ #category : 'Instance Creation' }
AIChatWindow class >> filePathString: filePathString chat: chat [

	^ self basicNew initializeWithFilePathString: filePathString chat: chat; yourself
]

{ #category : 'Instance Creation' }
AIChatWindow class >> fromFile: pathString [

	| fileStream |

	fileStream := CfsReadFileStream open: pathString.
	^ [ self filePathString: pathString chat: (Compiler evaluate: fileStream contents) ]
		ensure: [ fileStream close ]
]

{ #category : 'Instance Creation' }
AIChatWindow class >> new [

	^ self chat: AIChat new
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

	| sash selectedType unknown notSymbol |

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

	buttonWidget :=
		(self defaultWidgetParent
			createPushButton: 'button'
			argBlock: [:w |
				w
					labelString: 'Send';
					marginWidth: 10;
					addCallback: XmNactivateCallback
						receiver: self
						selector: #pushedButton:clientData:callData:
						clientData: nil]) manageChild.
	statusLine := (self newLabelWidget: #statusLineText) manageChild.

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
			orientation: XmHORIZONTAL].
	inputWidget parent setValuesBlock: [:w |
		w
			topAttachment: XmATTACHWIDGET;
			topWidget: sash;
			leftAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 35;
			rightAttachment: XmATTACHFORM].
	buttonWidget setValuesBlock: [:w |
		w
			topAttachment: XmATTACHWIDGET;
			topWidget: inputWidget;
			topOffset: 2;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 2;
			leftAttachment: XmATTACHFORM;
			leftOffset: 2].
	statusLine setValuesBlock: [:w |
		w
			topAttachment: XmATTACHWIDGET;
			topWidget: inputWidget;
			leftAttachment: XmATTACHWIDGET;
			leftWidget: buttonWidget;
			leftOffset: 5;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM].
			
	self updateStatusLine
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIChatWindow >> initializeAfterRealize [

	super initializeAfterRealize.
	self updateInput.
	inputWidget setInputFocus.
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

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> label [

	^ 'AI Assistant'
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
AIChatWindow >> menuActionChatAddFile [

	CwFileSelectionPrompter new prompt
		ifNotNil: [:selectedPathString | chat addFilePath: (CfsPath named: selectedPathString)]
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
				(self class fromFile: selectedPathString) open ].
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

	filePathString :=
		CwFileSelectionPrompter new
			accessType: XmSAVE;
			fileExtension: '.gc';
			prompt.
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
	"update the model used by chat to reflect change"
	(AIAbstractModel registeredModels contains: [:one | one = chat model])
		ifFalse: [chat model: nil].
	(chat model isNil and: [AIAbstractModel registeredModels size = 1])
		ifTrue: [chat model: AIAbstractModel registeredModels first].
	self updateInput
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
		chatWidget scrollToNextUserMessage.
		chat sendUserMessage: inputWidget value.
		self updateInput ].
	inputWidget value: ''.
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AIChatWindow >> statusLineText [

	| max |

	chat model isNil ifFalse: [max := chat model contextWindowSize].
	^chat tokenUsage printString , ' / ' , (max ifNil: ['?'] ifNotNil: [max printString])
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatWindow >> targetTextWidget: widget [

	super targetTextWidget: (widget ifNil: [ AIChatWidgetTargetTextWidgetAdapter for: chatWidget ])
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AIChatWindow >> update: aParameter [

	aParameter = #textSegments ifTrue: [self updateStatusLine].
	aParameter = #generating ifTrue: [self updateInput].
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

	^ statusLine labelString: self statusLineText
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIChatWindow >> windowClose: widget clientData: clientData callData: callData [

	super windowClose: widget clientData: clientData callData: callData.
	AIAbstractModel removeDependent: self.
	callData doit & chat notNil ifTrue: [
		chat removeDependent: self;
			stopGeneration ].
]
