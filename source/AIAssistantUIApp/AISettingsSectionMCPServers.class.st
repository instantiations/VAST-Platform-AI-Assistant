Class {
	#name : 'AISettingsSectionMCPServers',
	#superclass : 'AIAbstractSettingsSection',
	#instVars : [
		'displayedServers',
		'selectedServer',
		'serverList',
		'addServerButton',
		'removeServerButton',
		'nameInput',
		'urlInput',
		'serverListSelectionPending',
		'pendingServerNameUpdate'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> addServerButtonPressed: widget clientData: clientData callData: callData [

	selectedServer := AIMCPServerStreamableHTTP new.
	AIAbstractMCPServer registerServer: selectedServer.
	self updateInputs.
]

{ #category : 'Not categorized' }
AISettingsSectionMCPServers >> closeWindow [

	^ true
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> createServerDetails: form [

	| inputOffset labelOffset rightMargin widgetSpacing nameLabel urlLabel |

	inputOffset := 60.
	labelOffset := 4.
	rightMargin := 10.
	widgetSpacing := 5.

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

	(urlLabel := form createLabel: nil argBlock: [ :w | w labelString: 'URL:'; alignment: XmALIGNMENTEND ])
		manageChild.
	(urlInput := form createText: nil argBlock: nil)
		manageChild;
		addCallback: XmNlosingFocusCallback
			receiver: self
			selector: #urlInputLosingFocusOrActivated:clientData:callData:
			clientData: nil;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #urlInputLosingFocusOrActivated:clientData:callData:
			clientData: nil.

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
			topAttachment: XmATTACHFORM;
			topOffset: widgetSpacing;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin ].

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
			topAttachment: XmATTACHWIDGET;
			topWidget: nameInput;
			topOffset: widgetSpacing;
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
		ifEmpty: [ self updateInputs ]
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
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> update: aspect [

	aspect = #registeredServers ifTrue: [
		self updateServers ].
	aspect = #name ifTrue: [
		self updateServers.
		self updateInputs ].
	aspect = #url ifTrue: [
		self updateInputs ].
	super update: aspect
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionMCPServers >> updateInputs [

	| newNameInputValue newUrlInputValue |
	
	newNameInputValue := (selectedServer ifNotNil: [ selectedServer name ]) ifNil: [ '' ].
	newUrlInputValue := (selectedServer ifNotNil: [ selectedServer url ]) ifNil: [ '' ] ifNotNil: [ :url | url asString ].
	
	nameInput value = newNameInputValue ifFalse: [
		self noCallback: nameInput during: [ :w | w setString: newNameInputValue ] ].
	urlInput value = newUrlInputValue ifFalse: [
		self noCallback: urlInput during: [ :w | w setString: newUrlInputValue ] ].

	nameInput setSensitive: selectedServer notNil.
	urlInput setSensitive: selectedServer notNil.
	removeServerButton setSensitive: selectedServer notNil.
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
			self updateInputs ] ].
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
