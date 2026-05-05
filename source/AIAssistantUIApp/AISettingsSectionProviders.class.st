Class {
	#name : 'AISettingsSectionProviders',
	#superclass : 'AIAbstractSettingsSection',
	#instVars : [
		'providerList',
		'selectedProvider',
		'currentProvider',
		'unregisterButton',
		'newButton',
		'providerTypesCombo',
		'labelInput',
		'urlInput',
		'apiKeyInput',
		'modelList',
		'refreshModelsButton',
		'updateButton',
		'registerButton'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> apiKeyChanged: apiKey clientData: clientData callData: callData [
	"When a provider typeis selected, we can create a new, unregistered provider"

	currentProvider apiKey: apiKey value.
	self detailsChanged
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> checkProviderConnection [
	"Return true if we are able to connect to the provider with the current url/apiKey"
	
	[currentProvider refreshModels]
		on: SstConstants::ExSstNonFatalError
		do: [:sstErr | ^false].
	^true
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> checkProviderErrorMessage [
	"Return nil if we can connect to provider, or descriptive error text if not"
	
	[currentProvider refreshModels]
		on: SstConstants::ExSstNonFatalError
		do: [:sstEx | ^self errorMessageForSstException:  sstEx].
	^nil
]

{ #category : 'Initialization' }
AISettingsSectionProviders >> closeWindow [
	^self discardChanges
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> createProviderDetails: providerDetails [

	| inputOffset labelOffset rightMargin widgetSpacing buttonWidth providerTypesLabel labelLabel
	  urlLabel apiKeyLabel modelListLabel |

	inputOffset := 115.
	labelOffset := 4.
	rightMargin := 10.
	widgetSpacing := 5.
	buttonWidth := 48.

	providerTypesCombo :=
		providerDetails
			createComboBox: 'providerTypesCombo'
			argBlock: [:w |
				w
					items: (AIAbstractModelProvider allSubclasses collect: [:e | e apiLabel]);
					addCallback: XmNsingleSelectionCallback
						receiver: self
						selector: #providerTypeChanged:clientData:callData:
						clientData: nil].
	providerTypesLabel :=
		providerDetails
			createLabel: 'providerTypesLabel'
			argBlock: [:w |
				w
					labelString: 'Provider Type:';
					alignment: XmALIGNMENTEND].

	labelInput :=
		providerDetails
			createText: 'LabelText'
			argBlock: [:w |
				w
					addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #labelChanged:clientData:callData:
					clientData: nil].
	labelLabel :=
		providerDetails
			createLabel: 'LabelLabel'
			argBlock: [:w |
				w
					labelString: 'Label:';
					alignment: XmALIGNMENTEND].

	urlInput :=
		providerDetails
			createText: 'UrlHostText'
			argBlock: [:w |
				w
					addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #urlChanged:clientData:callData:
					clientData: nil].
	urlLabel :=
		providerDetails
			createLabel: 'UrlLabel'
			argBlock: [:w |
				w
					labelString: 'URL:';
					alignment: XmALIGNMENTEND].

	apiKeyInput :=
		providerDetails
			createText: 'APIKeyText'
			argBlock: [:w |
				w
					addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #apiKeyChanged:clientData:callData:
					clientData: nil].
	apiKeyLabel :=
		providerDetails
			createLabel: 'APIKeyLabel'
			argBlock: [:w |
				w
					labelString: 'API Key:';
					alignment: XmALIGNMENTEND].

	modelListLabel :=
		providerDetails
			createLabel: 'modelListLabel'
			argBlock: [:w |
				w
					labelString: 'Provider Models:';
					alignment: XmALIGNMENTEND].

	modelList :=
		providerDetails
			createScrolledList: 'modelList'
			argBlock: [:w | w foregroundColor: Color darkGray].
	modelList manageChild.

	refreshModelsButton :=
		providerDetails
			createPushButton: 'refreshModelsButton'
			argBlock: [:w |
				w
					labelString: 'Refresh';
					addCallback: XmNactivateCallback
						receiver: self
						selector: #updateModelsList:clientData:callData:
						clientData: modelList].

	updateButton :=
		providerDetails
			createPushButton: 'updateProviderButton'
			argBlock: [:w |
				w
					labelString: 'Save';
					addCallback: XmNactivateCallback
						receiver: self
						selector: #updateProviderButton:clientData:callData:
						clientData: nil].

	registerButton :=
		providerDetails
			createPushButton: 'registerProviderButton'
			argBlock: [:w |
				w
					labelString: 'Save';
					sensitive: false;
					addCallback: XmNactivateCallback
						receiver: self
						selector: #registerProviderButton:clientData:callData:
						clientData: nil].

	providerTypesCombo
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: inputOffset;
				topAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild.
	providerTypesLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: providerTypesCombo;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: providerTypesCombo;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: providerTypesCombo;
				bottomOffset: 2];
		manageChild.

	labelInput
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHWIDGET;
				leftOffset: inputOffset;
				topAttachment: XmATTACHWIDGET;
				topWidget: providerTypesCombo;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild.
	labelLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: labelInput;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: labelInput;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: labelInput;
				bottomOffset: 2];
		manageChild.

	urlInput
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHWIDGET;
				leftOffset: inputOffset;
				topAttachment: XmATTACHWIDGET;
				topWidget: labelInput;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild.
	urlLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: urlInput;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: urlInput;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: urlInput;
				bottomOffset: 2];
		manageChild.

	apiKeyInput
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHWIDGET;
				leftOffset: inputOffset;
				topAttachment: XmATTACHWIDGET;
				topWidget: urlInput;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild.
	apiKeyLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: apiKeyInput;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: apiKeyInput;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: apiKeyInput;
				bottomOffset: 2];
		manageChild.

	modelListLabel
		setValuesBlock: [:w |
			w
				rightAttachment: XmATTACHWIDGET;
				rightWidget: modelList parent;
				rightOffset: labelOffset;
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: modelList parent];
		manageChild.
	modelList parent
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: inputOffset;
				topAttachment: XmATTACHWIDGET;
				topWidget: apiKeyInput;
				topOffset: widgetSpacing * 2;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin;
				bottomAttachment: XmATTACHWIDGET;
				bottomWidget: registerButton;
				bottomOffset: 2];
		manageChild.
	refreshModelsButton
		setValuesBlock: [:w |
			w
				sensitive: false;
				topAttachment: XmATTACHWIDGET;
				topWidget: modelListLabel;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHOPPOSITEWIDGET;
				rightWidget: modelListLabel];
		manageChild.

	updateButton setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHOPPOSITEFORM;
			leftOffset: (rightMargin + buttonWidth) negated;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin;
			bottomAttachment: XmATTACHFORM].
	registerButton setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHOPPOSITEFORM;
			leftOffset: (rightMargin + buttonWidth) negated;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin;
			bottomAttachment: XmATTACHFORM]



]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> createSettingsPane: aForm [

	| providerSettings sash providerDetails |

	providerSettings := aForm createForm: 'ProviderSettingsForm' argBlock: nil.

	providerList :=
		providerSettings
			createScrolledList: 'ProviderList'
			argBlock: [:w |
				w
					items: self initialProviderList;
					selectionPolicy: XmSINGLESELECT;
					addCallback: XmNsingleSelectionCallback
						receiver: self
						selector: #providerChanged:clientData:callData:
						clientData: nil;
					manageChild].

	newButton :=
		providerSettings
			createPushButton: 'newProviderButton' "$NON-NLS$"
			argBlock: [:w |
				w
					labelString: '+';
					addCallback: XmNactivateCallback
						receiver: self
						selector: #newProviderButton:clientData:callData:
						clientData: nil].
	unregisterButton :=
		providerSettings
			createPushButton: 'unregisterProviderButton' "$NON-NLS$"
			argBlock: [:w |
				w
					labelString: '-';
					addCallback: XmNactivateCallback
						receiver: self
						selector: #unregisterProviderButton:clientData:callData:
						clientData: nil].
	sash :=
		CwSash
			createWidget: 'providerSettingsSash' "$NON-NLS$"
			parent: providerSettings
			argBlock: [:w | w orientation: XmVERTICAL].

	providerDetails := providerSettings createForm: 'ProviderDetailsForm' argBlock: [:w | ].

	self createProviderDetails: providerDetails.
	sash
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: 120;
				topAttachment: XmATTACHFORM;
				topOffset: 5;
				bottomAttachment: XmATTACHFORM;
				bottomOffset: 31
				"should be the following, but due to circular dependency warnings not considering 
				 horizontal and vertical constraints independently, leads to too much transcript clutter.
				 Change after warning check has been fixed, and the UI will automatically adjust to different button font sizes."
				"bottonAttachment: XmATTACHWIDGET;
				 bottomWidget: newButton;
				 bottomOffset: 1"];
		manageChild.

	providerList parent
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: 5;
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: sash;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: sash;
				rightOffset: 1;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: sash];
		manageChild.

	newButton
		setValuesBlock: [:w |
			w
				marginWidth: (w preferredExtent y - w preferredExtent x) // 2 + w marginWidth;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: sash;
				bottomAttachment: XmATTACHFORM ];
		manageChild.
	unregisterButton
		setValuesBlock: [:w |
			w
				marginWidth: (w preferredExtent y - w preferredExtent x) // 2 + w marginWidth;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: newButton;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: newButton];
		manageChild.

	providerDetails
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHWIDGET;
				leftWidget: sash;
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: providerList parent;
				rightAttachment: XmATTACHFORM;
				bottomAttachment: XmATTACHFORM];
		manageChild.

	providerSettings setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHFORM;
			topAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			rightOffset: 5;
			bottomAttachment: XmATTACHFORM].
	"Select first provider entry"
	providerList items isEmpty ifFalse: [providerList selectPos: 1 notify: true].
	^providerSettings
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> detailsChanged [

	labelInput sensitive: currentProvider notNil.
	urlInput sensitive: (currentProvider notNil and: [currentProvider class hasUniqueURL not]).
	refreshModelsButton sensitive: self providerModelsAccessible.
	apiKeyInput sensitive: self urlUsesSecureScheme.
	(selectedProvider isNil)
		ifTrue: [registerButton sensitive: self providerFullyDefined]
		ifFalse: [updateButton sensitive: (self providerFullyDefined and: [self providerDetailsChanged])]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> discardChanges [

	^(currentProvider isNil or: [currentProvider sameAs: selectedProvider]) or: [ | canSave
		  buttonIndex |
		canSave := self providerFullyDefined.
		buttonIndex :=
			AbtNamedButtonExtendedMessagePrompter
				message:
					('Provider <1s> has unsaved changes.' expandMacrosWith: currentProvider label)
				title: 'Unsaved Changes'
				iconType: XmDIALOGWARNING
				buttonNames: (canSave ifTrue: [#('Save')] ifFalse: [#()]) , #('Discard' 'Cancel').
		(canSave and: [buttonIndex = 1])
			ifTrue: [
				selectedProvider
					ifNil: [self registerProviderButton: registerButton clientData: nil callData: nil]
					ifNotNil: [self updateProviderButton: updateButton clientData: nil callData: nil].
				self discardChanges]
			ifFalse: [buttonIndex ~= (canSave ifTrue: [3] ifFalse: [2])]]
]

{ #category : 'Errors',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> errorMessageForSstException: anException [
	"An error occurred during operation, return a descriptive ErrorMessage"

	| sstError |

	sstError := anException arguments second.
	sstError errorCode = SstErrorConstants::SstInvalidAddressError
		ifTrue: [
			^'<1s> does not resolve to a valid address '
				expandMacrosWith: currentProvider baseUrl asString].
	sstError errorCode = SstErrorConstants::SstEndpointUnreachableError
		ifTrue: [
			^'<1s> cannot be reached.<n>Check connection details, and make sure it is running'
				expandMacrosWith: currentProvider label].
	sstError errorCode = SstErrorConstants::SstSendError ifTrue: [
		(sstError errorObject isString and: [(sstError errorObject indexOfSubCollection: 'SSL') > 0])
			ifTrue: [^'Failed to establish secure connection to <1s>' expandMacrosWith: currentProvider baseUrl asString]].
	sstError errorCode = SstErrorConstants::SstReceiveError
		ifTrue: [ "Google = 400 with incorrect API key, 403 without API key/ on http,  OpenAI = 401 with incorrect/without API key, 403 on http"
			(#('400 Bad Request' '401 Unauthorized' '403 Forbidden')
				includes: sstError errorObject header status)
					ifTrue: [
						currentProvider apiKey isNil
							ifTrue: [
								^'Access to <1s> denied, no API key set '
									expandMacrosWith: currentProvider label]
							ifFalse: [
								^'Access to <1s> denied on <2s> protocol  with API key set'
									expandMacrosWith: currentProvider label
									with: sstError errorObject sender preferredAccessibleUrl scheme]]].

	^'An unknown error occured'
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> initialProviderList [

	^ AIAbstractModelProvider registeredProviders collect: [ :provider | provider label ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> initialize [

	super initialize.
	AIAbstractModelProvider addDependent: self.
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> isRegistered: aProvider [
	^(AIAbstractModelProvider registeredProviders includes: currentProvider)
	
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> labelChanged: label clientData: clientData callData: callData [
	"When a provider typeis selected, we can create a new, unregistered provider"

	currentProvider label: label value.
	self detailsChanged
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> newProviderButton: a clientData: clientData callData: callData [

	providerList deselectAllItems.
	selectedProvider := currentProvider := nil.
	newButton sensitive: false.
	unregisterButton sensitive: false.
	self providerDetailsClear
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> noCallback: aWidget during: aBlock [

	| callbacks |

	callbacks := aWidget valueChangedCallback.
	[	aWidget valueChangedCallback: nil.
		aBlock value: aWidget]
			ensure: [aWidget valueChangedCallback: callbacks]
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> providerChanged: providers clientData: clientData callData: callData [
	self discardChanges
		ifFalse: [
			^selectedProvider isNil ifFalse: [providerList selectItem: selectedProvider label notify: false]].
	(providerList selectedItems first ~= callData item) ifTrue: [
		providerList selectItem: callData item notify: false ].
	selectedProvider := AIAbstractModelProvider labeled: callData item.
	"Operate on a copy, so we don't change details of currently registered provider until user accepts changes"
	currentProvider := selectedProvider copy.
.
	newButton sensitive:  true.
	unregisterButton sensitive: true.
	self providerDetailsUpdate
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> providerDetailsChanged [

	^(currentProvider sameAs: selectedProvider) not
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> providerDetailsClear [
	"Install values in provider fields based on selected model"
	"Empty and enable all detail fields to ready create new one"

	self
		noCallback: providerTypesCombo
		during: [:w |
			w
				sensitive: true;
				setString: ''].
	self noCallback: labelInput during: [:w | w setString: ''].
	self noCallback: urlInput during: [:w | w setString: ''].
	self noCallback: apiKeyInput during: [:w | w setString: ''].
	modelList items: #().
	registerButton manageChild.
	updateButton unmanageChild.
	self detailsChanged
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> providerDetailsUpdate [
	"Install values in provider fields based on selected model"
	"Fill detail fields with values from selectedProvider - disable changing providerType"

	self
		noCallback: providerTypesCombo
		during: [:w |
			w
				sensitive: false;
				setString: currentProvider class apiLabel].
	self noCallback: labelInput during: [:w | w setString: currentProvider label].
	self noCallback: urlInput during: [:w | w setString: currentProvider baseUrl printString].
	self noCallback: apiKeyInput during: [:w | w setString: (currentProvider apiKey ifNil: [''])].
	modelList items: (currentProvider models collect: [:each | each name]).
	registerButton unmanageChild.
	updateButton manageChild.
	self detailsChanged
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> providerFullyDefined [
	"Return true if all the fields needed to define a provider is set correctly"

	^self providerModelsAccessible and: [currentProvider label notEmpty]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> providerModelsAccessible [
	"Return true if all the fields needed to define a provider is set correctly"

	^currentProvider notNil and: [currentProvider baseUrl notNil]
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> providerTypeChanged: providerTypes clientData: clientData callData: callData [
	"When a provider type is selected, we can create a new, unregistered provider"
	
	|providerClass| 
	providerClass := AIAbstractModelProvider implementorLabeled: callData item.
	currentProvider := providerClass createNamed: labelInput value baseUrl: (urlInput value).
	currentProvider apiKey: apiKeyInput value.
	"In case provider unique, url may have changed"
	self noCallback: urlInput during: [:url | url setString: currentProvider baseUrl asString].
	self detailsChanged
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> registerProviderButton: a clientData: clientData callData: callData [
	"Register the currently edited provider"

	a
		sensitive: false;
		labelString: '...'.
	[
		[
			(self checkProviderErrorMessage) ifNotNil: [:errMsg |
				(CwMessagePrompter
					warn: ('<1s><n>Do you still want to add it?' expandMacrosWith: errMsg))
						ifNil: [^self]].
			currentProvider :=
				[AIAbstractModelProvider registerProvider: currentProvider]
					on: Error
					do: [:err | ^CwMessagePrompter errorMessage: err messageText]]
						ifCurtailed: [a sensitive: true].
		providerList selectItem: currentProvider label notify: true]
			ensure: [a labelString: 'Save']
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> registeredProvidersChanged [

	providerList deselectAllItems.
	providerList
		items: (AIAbstractModelProvider registeredProviders collect: [:each | each label]).

	currentProvider isNil
		ifTrue: [ "Update due to registration/removal in other window, while we had nothing being edited, so nothing to update"
			^self].
	(AIAbstractModelProvider labeled: currentProvider label)
		ifNotNil: [:registered | "Provider added or updated"
			currentProvider := nil.
			providerList selectItem: registered label notify: true]
		ifNil: [
			selectedProvider isNil
				ifFalse: [ "Provider unregistered"
					selectedProvider := currentProvider := nil.
					newButton sensitive: false.
					unregisterButton sensitive: false.
					self providerDetailsClear]]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> release [

	super release.
	AIAbstractModelProvider removeDependent: self.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> sectionChanged [

	selectedProvider ifNil: [
		currentProvider := nil.
		self providerDetailsClear
	] ifNotNil: [
		currentProvider := selectedProvider copy.
		self providerDetailsUpdate ]
]

{ #category : 'Accessing' }
AISettingsSectionProviders >> sectionLabel [
	^'Providers'
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> unregisterProviderButton: a clientData: clientData callData: callData [

	AIAbstractModelProvider unregisterProvider: selectedProvider ifUnregisteringModels: [
		(CwMessagePrompter warn: 'Models are registered, using this provider. Unregister them?') notNil ]
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> update: aSymbol [
	"Something we are interested in changed - react"

	aSymbol = #registeredProvidersChanged
		ifTrue: [
			self
				registeredProvidersChanged;
				detailsChanged]
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> updateModelsList: button clientData: listWidget callData: callData [

	| newModels |

	currentProvider ifNil: [^nil].
	button sensitive: false.
	[
		[newModels := currentProvider refreshModels]
			on: SstConstants::ExSstNonFatalError
			do: [:sstEx | ^CwMessagePrompter errorMessage: (self errorMessageForSstException: sstEx)].
		self detailsChanged.
		listWidget items: (newModels collect: [:each | each name])]
			ensure: [button sensitive: true]
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> updateProviderButton: a clientData: clientData callData: callData [

	a
		sensitive: false;
		labelString: '...'.

	[
		[
			(self checkProviderErrorMessage) ifNotNil: [:errMsg |
				(CwMessagePrompter
					warn: ('<1s><n>Do you still want to update it?' expandMacrosWith: errMsg))
						ifNil: [^self]].
			[AIAbstractModelProvider updateProvider: selectedProvider to: currentProvider]
				on: Error
				do: [:err | ^CwMessagePrompter errorMessage: err messageText]]
					ifCurtailed: [a sensitive: true]]
						ensure: [a labelString: 'Save']
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> urlChanged: url clientData: clientData callData: callData [
	"When a provider typeis selected, we can create a new, unregistered provider"

	currentProvider baseUrl: (self validUrl: url value).
	self detailsChanged
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> urlUsesSecureScheme [
	"There are other secure protocols than https - but we don't expect those to be used, 
	 and actually checking if a URL is secure requires initiating a connection"

	^self providerModelsAccessible
		and: [(currentProvider baseUrl scheme indexOfSubCollection: 'https') = 1]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionProviders >> validUrl: aString [
"mandatory hostname, and no path - provider endpoint urls construct those"
	^(SstHttpUrl fromString: urlInput value)
				ifNotNil: [:url | 
					(url address notEmpty and: [url path size = 1]) ifTrue: [url]]
]
