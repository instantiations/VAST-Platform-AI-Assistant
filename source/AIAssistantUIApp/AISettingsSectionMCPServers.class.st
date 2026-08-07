Class {
	#name : 'AISettingsSectionMCPServers',
	#superclass : 'AIAbstractSettingsSection',
	#instVars : [
		'displayedServers',
		'selectedServer',
		'serverList',
		'addServerButton',
		'removeServerButton',
		'transportComboBox',
		'nameInput',
		'stdioForm',
		'commandInput',
		'serverStatusLabel',
		'serverStderrText',
		'displayedStderrLines',
		'streamableHTTPForm',
		'urlInput',
		'serverListSelectionPending',
		'pendingServerNameUpdate'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> addServerButtonPressed: widget clientData: clientData callData: callData [

	selectedServer := AIMCPServerStdio new.
	AIAbstractMCPServer registerServer: selectedServer.
	self updateInputs; updateServerStatus; setServerStderrText.
]

{ #category : 'Not categorized' }
AISettingsSectionMCPServers >> closeWindow [

	^ true
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> commandInputLosingFocusOrActivated: widget clientData: clientData callData: callData [
	
	self for: commandInput doCallback: [
		| newCommand |
		newCommand := commandInput value ifEmpty: [ nil ].
		selectedServer command = newCommand ifFalse: [
			selectedServer command: newCommand; resetTools ] ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> createServerDetails: form [

	| inputOffset labelOffset rightMargin widgetSpacing transportLabel nameLabel commandLabel urlLabel |

	inputOffset := 80.
	labelOffset := 4.
	rightMargin := 10.
	widgetSpacing := 5.

	(transportLabel := form createLabel: nil argBlock: [ :w | w labelString: 'Transport:'; alignment: XmALIGNMENTEND ])
		manageChild.
	(transportComboBox := form createComboBox: nil argBlock: [ :w | w items: { AIMCPServerStdio label. AIMCPServerStreamableHTTP label } ])
		manageChild;
		addCallback: XmNsingleSelectionCallback
			receiver: self
			selector: #transportChanged:clientData:callData:
			clientData: nil.

	(nameLabel := form createLabel: nil argBlock: [ :w | w labelString: 'Name:'; alignment: XmALIGNMENTEND ])
		manageChild.
	(nameInput := form createText: nil argBlock: nil)
		manageChild;
		addCallback: XmNlosingFocusCallback
			receiver: self
			selector: #nameInputLosingFocusOrActivated:clientData:callData:
			clientData: nil;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #nameInputLosingFocusOrActivated:clientData:callData:
			clientData: nil.

	stdioForm := form createForm: nil argBlock: nil.
	(commandLabel := stdioForm createLabel: nil argBlock: [ :w | w labelString: 'Command:'; alignment: XmALIGNMENTEND ])
		manageChild.
	(commandInput := stdioForm createText: nil argBlock: nil)
		manageChild;
		addCallback: XmNlosingFocusCallback
			receiver: self
			selector: #commandInputLosingFocusOrActivated:clientData:callData:
			clientData: nil;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #commandInputLosingFocusOrActivated:clientData:callData:
			clientData: nil.
	(serverStatusLabel := stdioForm createLabel: nil argBlock: [ :w | w labelType: XmICON ])
		manageChild.
	(serverStderrText := stdioForm createScrolledText: 'serverOutput' argBlock: [ :w | w editMode: XmMULTILINEEDIT; wordWrap: true; setEditable: false ])
		manageChild.

	streamableHTTPForm := form createForm: nil argBlock: nil.
	(urlLabel := streamableHTTPForm createLabel: nil argBlock: [ :w | w labelString: 'URL:'; alignment: XmALIGNMENTEND ])
		manageChild.
	(urlInput := streamableHTTPForm createText: nil argBlock: nil)
		manageChild;
		addCallback: XmNlosingFocusCallback
			receiver: self
			selector: #urlInputLosingFocusOrActivated:clientData:callData:
			clientData: nil;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #urlInputLosingFocusOrActivated:clientData:callData:
			clientData: nil.

	transportLabel setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHOPPOSITEWIDGET;
			topWidget: transportComboBox;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: transportComboBox;
			rightOffset: labelOffset;
			bottomAttachment: XmATTACHOPPOSITEWIDGET;
			bottomWidget: transportComboBox;
			bottomOffset: 2 ].
	transportComboBox setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHFORM;
			leftOffset: inputOffset;
			topAttachment: XmATTACHFORM;
			topOffset: widgetSpacing;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin ].

	nameLabel setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHOPPOSITEWIDGET;
			topWidget: nameInput;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: nameInput;
			rightOffset: labelOffset;
			bottomAttachment: XmATTACHOPPOSITEWIDGET;
			bottomWidget: nameInput;
			bottomOffset: 2 ].
	nameInput setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHFORM;
			leftOffset: inputOffset;
			topAttachment: XmATTACHWIDGET;
			topWidget: transportComboBox;
			topOffset: widgetSpacing;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin ].

	stdioForm setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHWIDGET;
			topWidget: nameInput;
			topOffset: widgetSpacing;
			rightAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM ].

	commandLabel setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHOPPOSITEWIDGET;
			topWidget: commandInput;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: commandInput;
			rightOffset: labelOffset;
			bottomAttachment: XmATTACHOPPOSITEWIDGET;
			bottomWidget: commandInput;
			bottomOffset: 2 ].
	commandInput setValuesBlock: [ :w |
		w
			leftAttachment: XmATTACHWIDGET;
			leftOffset: inputOffset;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: serverStatusLabel;
			rightOffset: 2;
			topAttachment: XmATTACHFORM ].

	serverStatusLabel setValuesBlock: [ :w |
		w
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin;
			topOffset: 5 ].

	serverStderrText parent setValuesBlock: [ :w |
		w
			leftAttachment: XmATTACHFORM;
			leftOffset: inputOffset;
			topAttachment: XmATTACHWIDGET;
			topWidget: commandInput;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin;
			bottomAttachment: XmATTACHFORM ].

	streamableHTTPForm setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHWIDGET;
			topWidget: nameInput;
			topOffset: widgetSpacing;
			rightAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM ].

	urlLabel setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHOPPOSITEWIDGET;
			topWidget: urlInput;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: urlInput;
			rightOffset: labelOffset;
			bottomAttachment: XmATTACHOPPOSITEWIDGET;
			bottomWidget: urlInput;
			bottomOffset: 2 ].
	urlInput setValuesBlock: [ :w |
		w
			leftAttachment: XmATTACHWIDGET;
			leftOffset: inputOffset;
			topAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin ].
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> createSettingsPane: settingsForm [

	| form sash serverDetailsForm |

	form := settingsForm createForm: nil argBlock: nil.
	(serverList := form createScrolledList: 'serverList' argBlock: [ :w | w selectionPolicy: XmSINGLESELECT ])
		manageChild;
		addCallback: XmNsingleSelectionCallback
			receiver: self
			selector: #serverListSelectionChanged:clientData:callData:
			clientData: nil;
		addEventHandler: ButtonPressMask
			receiver: self
			selector: #serverListButtonPressed:clientData:callData:
			clientData: nil.
	(addServerButton := form createPushButton: nil argBlock: [ :w | w labelString: '+' ])
		manageChild;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #addServerButtonPressed:clientData:callData:
			clientData: nil.
	(removeServerButton := form createPushButton: nil argBlock: [ :w | w labelString: '-'])
		manageChild;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #removeServerButtonPressed:clientData:callData:
			clientData: nil.
	(sash := CwSash createWidget: nil parent: form argBlock: [ :w | w orientation: XmVERTICAL ])
		manageChild.
	(serverDetailsForm := form createForm: nil argBlock: nil)
		manageChild.
	self createServerDetails: serverDetailsForm.

	sash setValuesBlock: [ :w |
		w
			leftAttachment: XmATTACHFORM;
			leftOffset: 120;
			topAttachment: XmATTACHFORM;
			topOffset: 5;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 31 ].
	serverList parent setValuesBlock: [ :w |
		w
			leftAttachment: XmATTACHFORM;
			leftOffset: 5;
			topAttachment: XmATTACHOPPOSITEWIDGET;
			topWidget: sash;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: sash;
			rightOffset: 1;
			bottomAttachment: XmATTACHOPPOSITEWIDGET;
			bottomWidget: sash ].
	addServerButton setValuesBlock: [ :w |
		w
			marginWidth: (w preferredExtent y - w preferredExtent x) // 2 + w marginWidth;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: sash;
			bottomAttachment: XmATTACHFORM ].
	removeServerButton setValuesBlock: [ :w |
		w
			marginWidth: (w preferredExtent y - w preferredExtent x) // 2 + w marginWidth;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: addServerButton;
			bottomAttachment: XmATTACHOPPOSITEWIDGET;
			bottomWidget: addServerButton ].
	serverDetailsForm setValuesBlock: [ :w |
		w
			leftAttachment: XmATTACHWIDGET;
			leftWidget: sash;
			topAttachment: XmATTACHOPPOSITEWIDGET;
			topWidget: serverList parent;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM ].
	form setValuesBlock: [ :w |
		w
			leftAttachment: XmATTACHFORM;
			topAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			rightOffset: 5;
			bottomAttachment: XmATTACHFORM ].

	self updateServers.
	displayedServers
		ifEmpty: [ self updateInputs; updateServerStatus; setServerStderrText ]
		ifNotEmpty: [ serverList selectPos: 1 notify: true ].

	^ form
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> initialize [

	super initialize.
	displayedServers := OrderedCollection new.
	serverListSelectionPending := false.
	AIAbstractMCPServer addDependent: self.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> nameInputLosingFocusOrActivated: widget clientData: clientData callData: callData [
	
	self for: nameInput doCallback: [
		| newName |
		newName := nameInput value ifEmpty: [ nil ].
		selectedServer name = newName ifFalse: [
			serverListSelectionPending ifTrue: [
				pendingServerNameUpdate := selectedServer -> newName.
			] ifFalse: [
				selectedServer name: newName ] ] ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> release [

	super release.
	AIAbstractMCPServer removeDependent: self.
	displayedServers do: [ :server | server removeDependent: self ].
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> removeServerButtonPressed: widget clientData: clientData callData: callData [

	AIAbstractMCPServer unregisterServer: selectedServer
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> scheduleUpdate: updateBlock [

	serverListSelectionPending not ifTrue: [
		updateBlock value.
		^ self ].
	CwAppContext default 
		addWorkProc: [ :clientData |
			serverListSelectionPending not
				ifTrue: [
					updateBlock value. 
					true ]
				ifFalse: [ false ] ] 
		selector: #value: 
		clientData: nil
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> sectionChanged [

	"Do nothing"
]

{ #category : 'Not categorized' }
AISettingsSectionMCPServers >> sectionLabel [

	^ 'MCP Servers'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> serverListButtonPressed: widget clientData: clientData callData: callData [

	serverListSelectionPending := true
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> serverListSelectionChanged: widget clientData: clientData callData: callData [

	selectedServer := callData itemPosition = 0 ifFalse: [ displayedServers at: callData itemPosition ].
	serverListSelectionPending := false.
	pendingServerNameUpdate ifNotNil: [
		pendingServerNameUpdate key name: pendingServerNameUpdate value.
		pendingServerNameUpdate := nil
	] ifNil: [
		self updateInputs ].
	self updateServerStatus; setServerStderrText.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> setServerStderrText [

	displayedStderrLines := (selectedServer notNil and: [ selectedServer isStdio ]) ifTrue: [ selectedServer stderrLines ] ifFalse: [ #() ].
	serverStderrText value: (String streamContents: [ :stream |
		displayedStderrLines do: [ :line |
			line value do: [ :character |
				stream nextPut: (character isAscii ifTrue: [ character ] ifFalse: [ $? ]) ].
			stream nextPutAll: CldtConstants::LineDelimiter ] ]).
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> transportChanged: widget clientData: clientData callData: callData [

	(transportComboBox getString = AIMCPServerStdio label) = selectedServer isStdio ifFalse: [
		| oldServer newServerClass |
		oldServer := selectedServer.
		newServerClass := (transportComboBox getString = AIMCPServerStdio label) ifTrue: [ AIMCPServerStdio ] ifFalse: [ AIMCPServerStreamableHTTP ].
		(selectedServer := newServerClass new)
			name: oldServer name.
		self updateInputs; updateServerStatus; setServerStderrText.
		AIAbstractMCPServer replaceServer: oldServer by: selectedServer ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> update: aspect [

	aspect = #registeredServers ifTrue: [
		self updateServers ].
	aspect = #name ifTrue: [
		self updateServers.
		self updateInputs ].
	(#(command url) includes: aspect) ifTrue: [
		self updateInputs ].
	aspect = #isRunning ifTrue: [
		self updateServerStatus ].
	aspect = #stderrLines ifTrue: [
		self updateServerStderrText ].
	super update: aspect
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> updateInputs [

	| newTransportValue newNameInputValue newCommandInputValue newUrlInputValue |
	
	newTransportValue := selectedServer ifNotNil: [ selectedServer isStdio ifTrue: [ AIMCPServerStdio label ] ifFalse: [ AIMCPServerStreamableHTTP label ] ] ifNil: [ '' ].
	newNameInputValue := (selectedServer ifNotNil: [ selectedServer name ]) ifNil: [ '' ].
	newCommandInputValue := (selectedServer ifNotNil: [ selectedServer isStdio ifTrue: [ selectedServer command ] ]) ifNil: [ '' ].
	newUrlInputValue := (selectedServer ifNotNil: [ selectedServer isStreamableHTTP ifTrue: [ selectedServer url ] ]) ifNil: [ '' ] ifNotNil: [ :url | url asString ].
	
	transportComboBox value = newTransportValue ifFalse: [
		self noCallback: transportComboBox during: [ :w | w setString: newTransportValue ] ].
	nameInput value = newNameInputValue ifFalse: [
		self noCallback: nameInput during: [ :w | w setString: newNameInputValue ] ].
	commandInput value = newCommandInputValue ifFalse: [
		self noCallback: commandInput during: [ :w | w setString: newCommandInputValue ] ].
	urlInput value = newUrlInputValue ifFalse: [
		self noCallback: urlInput during: [ :w | w setString: newUrlInputValue ] ].

	transportComboBox setSensitive: (selectedServer notNil and: [ newCommandInputValue isEmpty & newUrlInputValue isEmpty ]).
	nameInput setSensitive: selectedServer notNil.
	commandInput setSensitive: selectedServer notNil.
	urlInput setSensitive: selectedServer notNil.
	((selectedServer isNil or: [ selectedServer isStdio ]) ifTrue: [ streamableHTTPForm ] ifFalse: [ stdioForm ]) unmanageChild.
	((selectedServer isNil or: [ selectedServer isStdio ]) ifTrue: [ stdioForm ] ifFalse: [ streamableHTTPForm ]) manageChild.
	removeServerButton setSensitive: selectedServer notNil.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> updateServerStatus [

	serverStatusLabel labelIcon: ((selectedServer notNil and: [ selectedServer isStdio ])
		ifTrue: [
			selectedServer isRunning
				ifTrue: [ SUnitBrowser greenBallIcon ]
				ifFalse: [
					selectedServer hasExitError
						ifTrue: [ SUnitBrowser redBallIcon ]
						ifFalse: [ SUnitBrowser grayBallIcon ] ] ]
		ifFalse: [ CgIcon unspecifiedIcon ])
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> updateServerStderrText [

	| stderrLines linesRemoved linesAdded charactersRemoved |

	(selectedServer notNil and: [ selectedServer isStdio ]) ifFalse: [ ^ self ].
	
	stderrLines := selectedServer stderrLines.
	linesRemoved := displayedStderrLines ifEmpty: [ 0 ] ifNotEmpty: [ (stderrLines first key min: displayedStderrLines last key + 1) - displayedStderrLines first key ].
	linesAdded := stderrLines ifEmpty: [ 0 ] ifNotEmpty: [ stderrLines last key - (stderrLines first key - 1 max: (displayedStderrLines ifEmpty: [ 0 ] ifNotEmpty: [ displayedStderrLines last key ])) ].
	
	charactersRemoved := (displayedStderrLines copyFrom: 1 to: linesRemoved) inject: 0 into: [ :total :line | total + line value size + CldtConstants::LineDelimiter size ].
	serverStderrText replace: 0 toPos: charactersRemoved value: ''.
	serverStderrText replace: serverStderrText getLastPosition toPos: serverStderrText getLastPosition value: (String streamContents: [ :stream |
		(stderrLines copyFrom: stderrLines size - linesAdded + 1 to: stderrLines size) do: [ :line |
			line value do: [ :character |
				stream nextPut: (character isAscii ifTrue: [ character ] ifFalse: [ $? ]) ].
			stream nextPutAll: CldtConstants::LineDelimiter ] ]).
	
	displayedStderrLines := stderrLines.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> updateServers [

	| newServers |

	newServers := AIAbstractMCPServer registeredServers copy.
	
	displayedServers do: [ :server |
		(newServers includes: server) ifFalse: [
			server removeDependent: self ] ].
	newServers do: [ :server |
		(displayedServers includes: server) ifFalse: [
			server addDependent: self ] ].
	
	displayedServers := newServers sorted: [ :server1 :server2 | (server1 name ifNil: [ 'Unnamed' ]) < (server2 name ifNil: [ 'Unnamed' ]) ].
	serverList items: (displayedServers collect: [ :server | server name ifNil: [ 'Unnamed' ] ]).
	
	selectedServer ifNotNil: [
		| selectedServerIndex |
		selectedServerIndex := displayedServers indexOf: selectedServer.
		selectedServerIndex > 0 ifTrue: [
			serverList selectPos: selectedServerIndex notify: false
		] ifFalse: [ 
			selectedServer := nil.
			serverList deselectAllItems.
			self updateInputs; updateServerStatus; setServerStderrText ] ].
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> urlInputLosingFocusOrActivated: widget clientData: clientData callData: callData [
	
	self for: urlInput doCallback: [
		| newURL |
		newURL := SstUrl fromString: urlInput value.
		selectedServer url = newURL ifFalse: [
			selectedServer url: newURL; resetTools ] ]
]
