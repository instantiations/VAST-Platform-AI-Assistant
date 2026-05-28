Class {
	#name : 'AISettingsSectionFunctions',
	#superclass : 'AIAbstractSettingsSection',
	#instVars : [
		'functionsSet',
		'functionsForm',
		'functionsRowColumn'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AISettingsSectionFunctions >> closeWindow [

	^ true
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> createFunctionsRowColumn [

	functionsRowColumn := functionsForm createRowColumn: nil argBlock: nil.
	functionsSet allFunctions do: [ :function |
		(functionsRowColumn createToggleButton: nil
			argBlock: [ :w |
				w set: (functionsSet isFunctionEnabled: function);
					labelString: function name ])
			manageChild;
			addCallback: XmNvalueChangedCallback
				receiver: self
				selector: #toggleButtonValueChanged:clientData:callData:
				clientData: function ].
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> createSettingsPane: settingsForm [

	| form scrolledWindow resetButton |

	form := settingsForm createForm: nil argBlock: nil.
	(scrolledWindow := form createScrolledWindow: nil argBlock: [ :w | w scrollingPolicy: XmAUTOMATIC ])
		manageChild.
	(functionsForm := scrolledWindow createForm: nil argBlock: nil)
		manageChild.
	self createFunctionsRowColumn.
	functionsRowColumn manageChild.

	(resetButton := form createPushButton: nil argBlock: [ :w |
		w labelString: 'Reset';
			marginLeft: 5;
			marginRight: 5 ])
		manageChild;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #resetButtonPressed:clientData:callData:
			clientData: nil.

	form setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM ].
	scrolledWindow setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: resetButton;
			bottomOffset: 2 ].
	resetButton setValuesBlock: [ :w |
		w
			rightAttachment: XmATTACHFORM;
			rightOffset: 15;
			bottomAttachment: XmATTACHFORM ].
	^ form
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> initialize [

	super initialize.
	(functionsSet := AIFunctionsSet current)
		addDependent: self.
	AIFunctionsSet addDependent: self.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> release [

	super release.
	functionsSet removeDependent: self.
	AIFunctionsSet removeDependent: self.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> resetButtonPressed: resetButton clientData: clientData callData: callData [

	AIFunctionsSet resetCurrent
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> sectionChanged [

	"Do nothing"
]

{ #category : 'Not categorized' }
AISettingsSectionFunctions >> sectionLabel [

	^ 'Functions'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> toggleButtonValueChanged: toggleButton clientData: function callData: callData [

	callData set ifTrue: [
		functionsSet enableFunction: function
	] ifFalse: [
		functionsSet disableFunction: function ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> update: aspect [

	aspect = #current ifTrue: [
		functionsSet removeDependent: self.
		functionsSet := AIFunctionsSet current.
		functionsSet addDependent: self ].
	(#(current functions) includes: aspect) ifTrue: [
		| oldRowColumn |
		oldRowColumn := functionsRowColumn.
		self createFunctionsRowColumn.
		functionsRowColumn manageChild.
		oldRowColumn destroyWidget ].
]
