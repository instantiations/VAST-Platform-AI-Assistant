Class {
	#name : 'AISettingsWindow',
	#superclass : 'EtWindow',
	#instVars : [
		'list',
		'settingsForm',
		'sectionModels',
		'settingPanes',
		'selectedProvider',
		'selectedModel'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Initialization' }
AISettingsWindow >> closeWindow [
	"Deny close if any of the sections object"

	^sectionModels
		inject: super closeWindow
		into: [:sub :next |
			sub and: [
				next closeWindow or: [
					"Switch to pane that denied window close"
					settingPanes do: [:e | e unmanageChild].
					(settingPanes at: (sectionModels indexOf: next)) manageChild.
					false]]]
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsWindow >> createSettingPanes: aForm [

	sectionModels := { AISettingsSectionProviders new. AISettingsSectionModels new }.
	settingPanes := sectionModels collect: [:each | each createSettingsPane: aForm]
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsWindow >> createWorkRegion [

	(settingsForm := self defaultWidgetParent createForm: 'CategoryDetails' argBlock: nil) manageChild.
	self createSettingPanes: settingsForm.
	(list :=
		self defaultWidgetParent
			createList: 'CategoryList'
			argBlock: [:w |
				w
					items: (sectionModels collect: [:each | each sectionLabel]);
					selectionPolicy: XmSINGLESELECT])
						manageChild;
						addCallback: XmNsingleSelectionCallback
							receiver: self
							selector: #sectionChanged:clientData:callData:
							clientData: nil.

	list
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHFORM;
				topOffset: 5;
				leftAttachment: XmATTACHFORM;
				leftOffset: 5;
				bottomAttachment: XmATTACHFORM];
		bottomOffset: 5.

	settingsForm setValuesBlock: [:w |
		w
			topAttachment: XmATTACHFORM;
			topOffset: 5;
			leftAttachment: XmATTACHWIDGET;
			leftWidget: list;
			leftOffset: 10;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 5]
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsWindow >> includeEditMenu [

	^ false
]

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsWindow >> includeFileMenu [

	^ false
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsWindow >> restartWindowFromSnapshot: widgetHierarchySnapshot [

	sectionModels do: [ :sectionModel | sectionModel release ].
	^ super restartWindowFromSnapshot: widgetHierarchySnapshot
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AISettingsWindow >> sectionChanged: a clientData: clientData callData: callData [

	settingPanes keysAndValuesDo: [ :index :settingPane |
		settingPane isManaged ifTrue: [
			| sectionModel |
			callData itemPosition = index ifTrue: [ ^ self ].
			sectionModel := sectionModels at: index.
			sectionModel closeWindow ifFalse: [
				list selectPos: index notify: false.
				^ self ].
			sectionModel sectionChanged ] ].
	settingPanes do: [:e | e unmanageChild].
	(settingPanes at: callData itemPosition) manageChild
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsWindow >> windowClose: widget clientData: clientData callData: callData [

	super windowClose: widget clientData: clientData callData: callData.
	callData doit ifTrue: [
		sectionModels do: [ :sectionModel | sectionModel release ] ]
]
