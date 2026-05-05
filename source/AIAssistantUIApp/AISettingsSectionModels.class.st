Class {
	#name : 'AISettingsSectionModels',
	#superclass : 'AIAbstractSettingsSection',
	#instVars : [
		'modelList',
		'selectedModel',
		'currentModel',
		'selectedProvider',
		'currentProvider',
		'unregisterButton',
		'newButton',
		'providerCombo',
		'modelNameCombo',
		'labelInput',
		'specificModelDetailsPane',
		'updateButton',
		'registerButton'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> addModelSpecificDetailsFrameTo: aPane [

	| rightMargin modelSpecificFrame modelSpecificForm |

	rightMargin := 10.
	modelSpecificFrame :=
		aPane
			createFrame: 'modelSpecificDetailsFrame'
			argBlock: [:w |
				w
					labelString: 'Model-specific Parameters'].
	modelSpecificForm := modelSpecificFrame createForm: 'modelSpecificFramedForm' argBlock: [:w | ].

	modelSpecificFrame
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: rightMargin;
				topAttachment: XmATTACHFORM;
				topOffset: 10;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild.

	modelSpecificForm
		manageChild.

	^modelSpecificForm
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> allDetailsClear [
	"Clear all fields, to specify new model from scratch"
	self
		noCallback: providerCombo
		during: [:w |
			w
				sensitive: true;
				setString: ''].
	modelNameCombo items: #(); sensitive: false.
	self modelDetailsClear.
	
	updateButton unmanageChild.
	registerButton manageChild.
]

{ #category : 'Initialization' }
AISettingsSectionModels >> closeWindow [
	^self discardChanges
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsSectionModels >> createModelDetails: modelDetails [

	| rightMargin widgetSpacing buttonWidth generalModelDetailsPane |

	rightMargin := 10.
	widgetSpacing := 5.
	buttonWidth := 48.

	generalModelDetailsPane := modelDetails createForm: 'GeneralModelDetailsForm' argBlock: nil.
	self createModelDetailsGeneral: generalModelDetailsPane.
	specificModelDetailsPane := modelDetails createForm: 'SpecificModelDetailsForm' argBlock: [:w | ].

	updateButton :=
		modelDetails
			createPushButton: 'updateModelButton'
			argBlock: [:w |
				w
					labelString: 'Save';
					addCallback: XmNactivateCallback
						receiver: self
						selector: #updateModelButton:clientData:callData:
						clientData: nil].
	registerButton :=
		modelDetails
			createPushButton: 'registerModelButton'
			argBlock: [:w |
				w
					labelString: 'Save';
					sensitive: false;
					addCallback: XmNactivateCallback
						receiver: self
						selector: #registerModelButton:clientData:callData:
						clientData: nil].

	generalModelDetailsPane
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHFORM;
				leftAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM];
		manageChild.
	specificModelDetailsPane
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHWIDGET;
				topWidget: generalModelDetailsPane;
				topOffset: widgetSpacing;
				leftAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				bottomAttachment: XmATTACHWIDGET;
				bottomWidget: registerButton];
		manageChild.

	updateButton setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHOPPOSITEFORM;
			leftOffset: (rightMargin + buttonWidth) negated;
			rightAttachment: XmATTACHFORM;
			rightOffset: rightMargin;
			bottomAttachment: XmATTACHFORM].
	registerButton
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHOPPOSITEFORM;
				leftOffset: (rightMargin + buttonWidth) negated;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin;
				bottomAttachment: XmATTACHFORM];
		manageChild
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsSectionModels >> createModelDetailsGeneral: modelDetailsGeneral [

	| inputOffset labelOffset rightMargin widgetSpacing providerLabel modelNameLabel labelLabel |

	inputOffset := 75.
	labelOffset := 4.
	rightMargin := 10.
	widgetSpacing := 5.

	providerLabel :=
		modelDetailsGeneral createLabel: 'providerLabel' argBlock: [:w | w labelString: 'Provider:'].
	providerCombo :=
		modelDetailsGeneral
			createComboBox: 'providerCombo'
			argBlock: [:w |
				w
					items: self initialProviderList;
					addCallback: XmNsingleSelectionCallback
						receiver: self
						selector: #providerChanged:clientData:callData:
						clientData: nil].

	modelNameLabel :=
		modelDetailsGeneral
			createLabel: 'modelNameLabel'
			argBlock: [:w |
				w
					labelString: 'Model:';
					alignment: XmALIGNMENTEND].
	modelNameCombo :=
		modelDetailsGeneral
			createComboBox: 'nameCombo'
			argBlock: [:w |
				w
					addCallback: XmNsingleSelectionCallback
					receiver: self
					selector: #modelNameChanged:clientData:callData:
					clientData: nil].

	labelLabel :=
		modelDetailsGeneral
			createLabel: 'labelLabel'
			argBlock: [:w |
				w
					labelString: 'Label:';
					alignment: XmALIGNMENTEND].
	labelInput :=
		modelDetailsGeneral
			createText: 'labelInput'
			argBlock: [:w |
				w
					addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #labelChanged:clientData:callData:
					clientData: nil].

	providerCombo
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: inputOffset;
				topAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild.
	providerLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: providerCombo;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: providerCombo;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: providerCombo;
				bottomOffset: 2];
		manageChild.
		
	modelNameCombo
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: inputOffset;
				topAttachment: XmATTACHWIDGET;
				topWidget: providerCombo;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild.
	modelNameLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: modelNameCombo;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: modelNameCombo;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: modelNameCombo;
				bottomOffset: 2];
		manageChild.

	labelInput
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: inputOffset;
				topAttachment: XmATTACHWIDGET;
				topWidget: modelNameCombo;
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
		manageChild
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsSectionModels >> createSettingsPane: aForm [

	| modelSettings sash modelDetailsPane |

	modelSettings := aForm createForm: 'ModelSettingsForm' argBlock: nil.

	modelList :=
		modelSettings
			createScrolledList: 'ModelList'
			argBlock: [:w |
				w
					items: self initialModelList;
					selectionPolicy: XmSINGLESELECT;
					addCallback: XmNsingleSelectionCallback
						receiver: self
						selector: #modelChanged:clientData:callData:
						clientData: nil;
					manageChild].
	sash :=
		CwSash
			createWidget: 'modelSettingsSash'
			parent: modelSettings
			argBlock: [:w | w orientation: XmVERTICAL].

	newButton :=
		modelSettings
			createPushButton: 'newModelButton'
			argBlock: [:w |
				w
					labelString: '+';
					addCallback: XmNactivateCallback
						receiver: self
						selector: #newModelButton:clientData:callData:
						clientData: nil].
	unregisterButton :=
		modelSettings
			createPushButton: 'removeModelButton'
			argBlock: [:w |
				w
					labelString: '-';
					addCallback: XmNactivateCallback
						receiver: self
						selector: #unregisterModelButton:clientData:callData:
						clientData: nil].

	modelDetailsPane := modelSettings createForm: 'ModelDetailsCommonForm' argBlock: [:w | ].
	self createModelDetails: modelDetailsPane.

	sash
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftOffset: 165;
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
	modelList parent
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
				bottomAttachment: XmATTACHFORM];
		manageChild.
	unregisterButton
		setValuesBlock: [:w |
			w
				marginWidth: (w preferredExtent y - w preferredExtent x) // 2 + w marginWidth;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: newButton;
				bottomAttachment: XmATTACHFORM];
		manageChild.

	modelDetailsPane
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHWIDGET;
				leftWidget: sash;
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: modelList parent;
				rightAttachment: XmATTACHFORM;
				bottomAttachment: XmATTACHFORM];
		manageChild.

	modelSettings setValuesBlock: [:w |
		w
			leftAttachment: XmATTACHFORM;
			topAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			rightOffset: 5;
			bottomAttachment: XmATTACHFORM].
	"Select first model entry"
	modelList items isEmpty ifFalse: [modelList selectPos: 1 notify: true].
	^modelSettings
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> detailsChanged [

	| canChangeModel |

	canChangeModel := currentProvider notNil and: [selectedModel isNil].
	modelNameCombo sensitive: canChangeModel.
	(selectedModel isNil)
		ifTrue: [registerButton sensitive: self modelFullyDefined]
		ifFalse: [updateButton sensitive: (self modelFullyDefined and: [self modelDetailsChanged])]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> discardChanges [

	^(currentModel isNil or: [currentModel sameAs: selectedModel]) or: [ | canSave buttonIndex |
		canSave := self modelFullyDefined.
		buttonIndex :=
			AbtNamedButtonExtendedMessagePrompter
				message: ('Model <1s> has unsaved changes.' expandMacrosWith: currentModel label)
				title: 'Unsaved Changes'
				iconType: XmDIALOGWARNING
				buttonNames: (canSave ifTrue: [#('Save')] ifFalse: [#()]) , #('Discard' 'Cancel').
		(canSave and: [buttonIndex = 1])
			ifTrue: [
				selectedModel
					ifNil: [self registerModelButton: registerButton clientData: nil callData: nil]
					ifNotNil: [self updateModelButton: updateButton clientData: nil callData: nil].
				self discardChanges]
			ifFalse: [buttonIndex ~= (canSave ifTrue: [3] ifFalse: [2])]]
]

{ #category : 'Errors',
  #vaVisibility : 'private' }
AISettingsSectionModels >> errorMessageForSstException: anException [
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
AISettingsSectionModels >> initialModelList [

	^ AIAbstractModel registeredModels collect: [ :model | model label ]
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AISettingsSectionModels >> initialProviderList [
		
	^ AIAbstractModelProvider registeredProviders collect: [ :provider | provider label ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionModels >> initialize [

	super initialize.
	AIAbstractModelProvider addDependent: self.
	AIAbstractModel addDependent: self.
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> labelChanged: label clientData: clientData callData: callData [
	"When a provider typeis selected, we can create a new, unregistered provider"

	currentModel label: label value.
	self detailsChanged
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelChanged: a clientData: clientData callData: callData [

	self discardChanges
		ifFalse: [
			^selectedModel isNil ifFalse: [modelList selectItem: selectedModel label notify: false]].
	(modelList selectedItems first ~= callData item) ifTrue: [
		modelList selectItem: callData item notify: false ].
	selectedModel := AIAbstractModel labeled: callData item.
	"Operate on a copy, so we don't change details of currently registered model until user accepts changes"
	currentModel := selectedModel copy.
	currentProvider := currentModel provider.

	registerButton unmanageChild.
	updateButton manageChild.

	newButton sensitive: true.
	unregisterButton sensitive: true.
	self modelDetailsUpdate
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelDetailsChanged [

	^(currentModel sameAs: selectedModel) not
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelDetailsClear [
	"Clear all fields containing model details"

	self noCallback: labelInput during: [:w | w setString: ''; sensitive: false].

	self modelSpecificDetailsClear.
	
	self detailsChanged
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelDetailsUpdate [
	"Install values in model detail fields based on selected model"
	"Fill detail fields with values from selectedModel - disable changing providerType"

	self
		noCallback: providerCombo
		during: [:w |
			w
				sensitive: selectedModel isNil;
				setString: currentProvider label].
	self
		noCallback: modelNameCombo
		during: [:w |
			w
				sensitive: selectedModel isNil;
				items: (currentProvider models collect: [:each | each name]);
				setString: currentModel name].
	self noCallback: labelInput during: [:w | w sensitive: true; setString: currentModel label].
	
	self modelSpecificDetailsUpdate.

	self detailsChanged
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelFullyDefined [
	^currentModel notNil and: [currentModel label notEmpty]
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelNameChanged: modelName clientData: clientData callData: callData [

	currentModel := (currentProvider models detect: [:one | one name = callData item]) copy.
	self noCallback: labelInput during: [:w | w setString: currentModel label].
	self modelDetailsUpdate
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelSpecificDetailsClear [
	"Remove any fields on the model specific pane "

	specificModelDetailsPane children copy do: [:child | child destroyWidget].
	"Invalidate the whole pane, something is off with CwFrame invalidation when cleared"
	specificModelDetailsPane unmanageChild; manageChild.


]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> modelSpecificDetailsUpdate [
	"Update to show the specific detail fields for a model"

	self modelSpecificDetailsClear.
	currentModel hasParameters
		ifTrue: [| detailsFrame |
			detailsFrame := self addModelSpecificDetailsFrameTo: specificModelDetailsPane.
			currentModel addSpecificDetailsTo: detailsFrame in: self]
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionModels >> newModelButton: a clientData: clientData callData: callData [
	
	modelList deselectAllItems.
	currentProvider := selectedModel := currentModel :=nil.
	newButton sensitive: false.
	unregisterButton sensitive: false.
	self allDetailsClear
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AISettingsSectionModels >> noCallback: aWidget during: aBlock [

	| callbacks |

	callbacks := aWidget valueChangedCallback.
	[	aWidget valueChangedCallback: nil.
		aBlock value: aWidget]
			ensure: [aWidget valueChangedCallback: callbacks]
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> providerChanged: providerComboWidget clientData: clientData callData: callData [

	currentProvider := AIAbstractModelProvider labeled: providerCombo getString.
	currentProvider
		ifNil: [
			modelNameCombo items: #()]
		ifNotNil: [:provider |
			modelNameCombo items: (provider models collect: [:each | each name])].
		self modelDetailsClear
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> reasoningEffortChanged: reasoningSummaryCombo clientData: clientData callData: callData [

	currentModel reasoningEffort: reasoningSummaryCombo getString.
	self detailsChanged
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> reasoningSummaryChanged: reasoningSummaryCombo clientData: clientData callData: callData [

	currentModel reasoningSummary: reasoningSummaryCombo getString.
	self detailsChanged
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionModels >> registerModelButton: a clientData: clientData callData: callData [
	"Register a new model based on input fields.
	 Set currentModel to a copy ready for editing"
	[AIAbstractModel registerModel: currentModel] on: Error do: [:err | ^CwMessagePrompter errorMessage: err messageText].
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> registeredModelsChanged [

	modelList deselectAllItems.
	modelList items: (AIAbstractModel registeredModels collect: [:each | each label]).

	currentModel isNil
		ifTrue: [ "Update due to registration/removal in other window, while we had nothing being edited, so nothing to update"
			^self].
	(AIAbstractModel labeled: currentModel label)
		ifNotNil: [:registered | "Model added or updated"
			currentModel := nil.
			modelList selectItem: registered label notify: true]
		ifNil: [
			selectedModel isNil
				ifFalse: [
					"Update due to unregistration, or selectedModel was unregistered due to provider unregisteration"
					selectedModel := currentModel := nil.
					newButton sensitive: false.
					unregisterButton sensitive: false.
					self allDetailsClear]]
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> registeredProvidersChanged [

	providerCombo
		items: (AIAbstractModelProvider registeredProviders collect: [:each | each label]).
	(currentProvider notNil and: [(AIAbstractModelProvider labeled: currentProvider label) notNil])
		ifTrue: [
			"selected provider may have changed label, or had its models updated"
			providerCombo setString: currentProvider label.
			modelNameCombo items: (currentProvider models collect: [:each | each name]).
			"provider change causing currentModel removal is handled by registeredModelsChanged, so just reselect it"
			(currentModel notNil)
				ifTrue: [modelNameCombo setString: currentModel name]
			]
		ifFalse: [
				"Current provider was removed"
				currentProvider := nil.
				self allDetailsClear]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionModels >> release [

	super release.
	AIAbstractModelProvider removeDependent: self.
	AIAbstractModel removeDependent: self.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionModels >> sectionChanged [

	selectedModel ifNil: [
		currentModel := nil.
		self modelDetailsClear
	] ifNotNil: [
		currentModel := selectedModel copy.
		self modelDetailsUpdate ]
]

{ #category : 'Accessing' }
AISettingsSectionModels >> sectionLabel [
	^'Models'
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> temperatureChanged: temperatureInput clientData: clientData callData: callData [

	currentModel temperature: (Number readFrom: temperatureInput value ifFail: [nil]).
	self detailsChanged
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> top_pChanged: top_pInput clientData: clientData callData: callData [

	currentModel top_p: (Number readFrom: top_pInput value ifFail: [nil]).
	self detailsChanged
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionModels >> unregisterModelButton: a clientData: clientData callData: callData [

	AIAbstractModel unregisterModel: selectedModel.
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> update: aSymbol [
	"Something we are interested in changed - react"
	aSymbol = #registeredModelsChanged ifTrue: [^self registeredModelsChanged].
	 aSymbol = #registeredProvidersChanged ifTrue: [^self registeredProvidersChanged]
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsSectionModels >> updateModelButton: a clientData: clientData callData: callData [

	AIAbstractModel updateModel: selectedModel to: currentModel
]
