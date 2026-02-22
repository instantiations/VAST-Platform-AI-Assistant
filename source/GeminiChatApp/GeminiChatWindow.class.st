Class {
	#name : 'GeminiChatWindow',
	#superclass : 'EtWindow',
	#instVars : [
		'filePathString',
		'chat',
		'chatMenu',
		'chatWidget',
		'buttonWidget',
		'statusLine',
		'inputWidget'
	],
	#pools : [
		'CwConstants'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Instance Creation' }
GeminiChatWindow class >> chat: chat [

	^ self filePathString: nil chat: chat
]

{ #category : 'ET-Internal' }
GeminiChatWindow class >> desiredWindowSize [
	"Answer the desired window size."

	^self windowRatio * (700 @ 600)
]

{ #category : 'Instance Creation' }
GeminiChatWindow class >> filePathString: filePathString chat: chat [

	^ self basicNew initializeWithFilePathString: filePathString chat: chat; yourself
]

{ #category : 'Instance Creation' }
GeminiChatWindow class >> fromFile: pathString [

	| fileStream |

	fileStream := CfsReadFileStream open: pathString.
	^ [ self filePathString: pathString chat: (Compiler evaluate: fileStream contents) ]
		ensure: [ fileStream close ]
]

{ #category : 'Instance Creation' }
GeminiChatWindow class >> new [

	^ self chat: GeminiChat new
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> closeWindow [

	chat ifNotNil: [ chat removeDependent: self ].
	^ super closeWindow
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> createMenusBeforeWorkRegion [

	self menuBar
		addMenu: self menuChat;
		addMenu: self menuEdit;
		addMenu: self menuOptions;
		addMenu: self menuDebug;
		addMenu: self menuHelp
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> createWorkRegion [

	| sash |

	sash := (self newSash: XmHORIZONTAL) manageChild.
	chatWidget := (GeminiChatWidget createWidget: 'chat' parent: self defaultWidgetParent argBlock: [:w | ]) manageChild.
	chatWidget chat: chat.
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

	buttonWidget :=
		(self defaultWidgetParent
			createPushButton: 'button'
			argBlock: [:w |
				w
					labelString: 'Send';
					marginWidth: 10;
					addCallback: XmNactivateCallback
						receiver: self
						selector: #pushedSendButton:clientData:callData:
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

{ #category : 'User Interface' }
GeminiChatWindow >> initializeAfterRealize [

	super initializeAfterRealize.
	inputWidget setInputFocus.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
GeminiChatWindow >> initializeWithFilePathString: initialFilePathString chat: initialChat [

	super initialize.
	filePathString := initialFilePathString.
	chat := initialChat.
	chat addDependent: self
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> keyPressedInInputWidget: widget clientData: clientData callData: callData [

	(callData keysym = XKReturn and: [ (callData state noMask: ShiftMask) and: [ buttonWidget sensitive ] ]) ifTrue: [
		self sendUserMessage ]
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> label [

	^ 'Gemini AI Assistant'
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionChatAddFile [

	CwFileSelectionPrompter new prompt
		ifNotNil: [:selectedPathString | chat addFilePath: (CfsPath named: selectedPathString)]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionChatNew [

	self class new open
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionChatOpen [

	(CwFileSelectionPrompter new
			fileExtension: '.gc';
			prompt) ifNotNil: [ :selectedPathString |
				(self class fromFile: selectedPathString) open ].
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionChatSave [

	filePathString ifNil: [ ^ self menuActionChatSaveAs ].
	self saveToFile: filePathString
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionChatSaveAs [

	filePathString :=
		CwFileSelectionPrompter new
			accessType: XmSAVE;
			fileExtension: '.gc';
			prompt.
	filePathString ifNotNil: [:selectedPathString | self saveToFile: selectedPathString]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionEditCopy [

	chatWidget selectedString ifNotEmpty: [ :selectedString |
		selectedString asEsString ifNotNil: [ :esString |
			esString copyToClipboard ] ]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionInspectChat [

	self inspect
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionInspectLog [

	GeminiLog current entries inspect
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionSelectModel: aModel [

	chat model: aModel.
	GeminiModel default: aModel.
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuActionSetApiKey [

	| newKey |
	newKey := CwTextPrompter new
		title: 'Set Gemini API Key';
		messageString: 'Enter your Gemini API Key:';
		answerString: (GeminiChat apiKey ifNil: ['']);
		prompt.

	newKey ifNotNil: [
		GeminiChat apiKey: newKey.
		self updateStatusLine.
		self updateInput: chat isActivelyGenerating not ]
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuChat [
	
	chatMenu ifNotNil: [ ^ chatMenu ].
	chatMenu :=
		self newMenu
			title: 'Chat';
			subMenuSelector: #menuChat;
			add: #menuActionChatNew label: 'New' enable: true for: nil;
			add: #menuActionChatOpen label: 'Open...' enable: true for: nil;
			add: #menuActionChatSave label: 'Save' enable: true for: nil;
			add: #menuActionChatSaveAs label: 'Save As...'enable: true for: nil;
			addLine;
			add: #menuActionChatAddFile label: 'Add File...'enable: true for: nil.
			
	^chatMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuDebug [

	| debugMenu |
	debugMenu := self newMenu.
	debugMenu
		title: 'Debug';
		add: #menuActionInspectChat label: 'Inspect Chat' enable: true for: nil;
		add: #menuActionInspectLog label: 'Inspect Log' enable: true for: nil.
	^ debugMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuEdit [

	editMenu notNil ifTrue: [^editMenu].
	^editMenu := self newMenu
		title: 'Edit';
		subMenuSelector: #menuEdit;
		add: #menuActionEditCopy label: 'Copy' enable: [ true ] for: nil
		accelerator: (CwAccelerator mask: ControlMask keysym: XKc)
		acceleratorText: 'Ctrl+C'
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuHelp [

	| helpMenu |
	helpMenu := self newMenu.
	helpMenu
		title: 'Help';
		add: #openDocumentation label: 'Documentation' enable: false for: nil;
		add: #openAboutDialog label: 'About Gemini Chat...' enable: true for: nil.
	^ helpMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuModelOptions [

	| modelOptionsMenu |

	(modelOptionsMenu := self newMenu)
		title: 'Model';
		subMenuSelector: #menuModelOptions;
		owner: self.

	GeminiModel all do: [ :model |
		modelOptionsMenu add: (DirectedMessage selector: #menuActionSelectModel: arguments: { model } receiver: self)
			label: model label
			toggle: [ model = chat model ] ].

	^ modelOptionsMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> menuOptions [
	| optionsMenu |
	optionsMenu := self newMenu.
	optionsMenu
		title: 'Options';
		addSubMenu:  #menuModelOptions label: 'Model' enable: true for: self;
		addLine;
		add: #menuActionSetApiKey label: 'Set API Key...' enable: true for: self.
	^ optionsMenu
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> openAboutDialog [

	CwMessagePrompter
		message: 'Gemini Chat for VAST Platform', String cr,
				 'A Smalltalk Code Assistant using Google''s Gemini AI.', String cr, String cr,
				 'Copyright (c) 2026'
		title: 'About Gemini Chat'
		iconType: XmICONINFO
]

{ #category : 'Operations' }
GeminiChatWindow >> pushedSendButton: button clientData: clientData callData: callData [

	self sendUserMessage
]

{ #category : 'Operations' }
GeminiChatWindow >> saveToFile: pathString [

	| fileStream |

	fileStream := CfsWriteFileStream openEmpty: pathString.
	[
		chat storeOn: fileStream.
		filePathString := pathString
	] ensure: [ fileStream close ]
]

{ #category : 'Operations',
  #vaVisibility : 'private' }
GeminiChatWindow >> sendUserMessage [

	inputWidget value ifNotEmpty: [
		self updateInput: false.
		chatWidget scrollToNextUserMessage.
		chat sendUserMessage: inputWidget value ].
	inputWidget value: ''.
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> statusLineText [

	| usage total max |
	(GeminiChat apiKey isNil or: [ GeminiChat apiKey isEmpty ]) ifTrue: [
		^ 'Please enter a valid API key in Options > Set API Key...' ].

	usage := chat usageMetadata.
	usage ifNil: [ ^ 'Tokens: - / -' ].
	total := usage at: 'totalTokenCount' ifAbsent: [ 0 ].
	max := chat model contextWindowSize.
	^ 'Tokens: ', total printString, ' / ', (max ifNil: ['?'] ifNotNil: [max printString])
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> update: aParameter [

	aParameter = #textSegments ifTrue: [
		self updateStatusLine].
	aParameter = #generating ifTrue:[ 
		self updateInput: true].
	super update: aParameter
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> updateInput: beActive [

	| beSensitive |

	beSensitive := beActive and: [ GeminiChat apiKey notNil and: [ GeminiChat apiKey notEmpty ] ].
	inputWidget foregroundColor: (beSensitive ifTrue: [ Color black ] ifFalse: [ Color darkGray ]).
	buttonWidget sensitive: beSensitive.
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
GeminiChatWindow >> updateStatusLine [

	"Private - Update the status line."

	^ statusLine labelString: self statusLineText
]
