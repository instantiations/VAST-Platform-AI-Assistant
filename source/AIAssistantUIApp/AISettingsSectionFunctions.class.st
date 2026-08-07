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

{ #category : 'Not categorized' }
AISettingsSectionFunctions >> createFunctionsRowColumn [

	| isFirstCategory |

	functionsRowColumn := functionsForm createRowColumn: nil argBlock: nil.
	isFirstCategory := true.
	functionsSet functionsByCategory keysAndValuesDo: [ :category :categoryFunctions |
		(functionsRowColumn createLabel: nil argBlock: [ :w | 
			w labelString: category; 
				marginTop: (isFirstCategory ifTrue: [ 0 ] ifFalse: [ 10 ]);
				fontList: (CwFontList named: ((w parent defaultFont: w) fontStruct logicalFontDescription weight: 'bold'; name)) ])
					manageChild.
		categoryFunctions do: [ :function |
			| isEnabled requiresPermission functionForm toggleButton radioBox |

			isEnabled := functionsSet isFunctionEnabled: function.
			requiresPermission := functionsSet requiresPermissionToCallFunction: function.

			(functionForm := functionsRowColumn createForm: nil argBlock: nil)
				manageChild.
			(toggleButton := functionForm createToggleButton: nil
				argBlock: [ :w |
					w set: isEnabled;
						labelString: function name ])
				manageChild;
				addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #toggleButtonValueChanged:clientData:callData:
					clientData: function.
			(radioBox := functionForm createRadioBox: nil argBlock: [ :w | 
				w 
					packing: XmPACKTIGHT;
					orientation: XmHORIZONTAL;
					marginHeight: 0 ])
				manageChild.
			(radioBox createToggleButton: nil argBlock: [ :w | w labelString: 'Always Allow'; set: requiresPermission not ])
				manageChild;
				addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #radioButtonAlwaysValueChanged:clientData:callData:
					clientData: function.
			(radioBox createToggleButton: nil argBlock: [ :w | w labelString: 'Ask'; set: requiresPermission ])
				manageChild;
				addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #radioButtonAskValueChanged:clientData:callData:
					clientData: function.
			
			toggleButton setValuesBlock: [ :w |
				w topAttachment: XmATTACHFORM;
					leftAttachment: XmATTACHFORM;
					leftOffset: 3;
					rightAttachment: XmATTACHFORM;
					bottomAttachment: XmATTACHWIDGET;
					bottomWidget: radioBox;
					bottomOffset: -3 ].
			radioBox setValuesBlock: [ :w |
				w leftAttachment: XmATTACHFORM;
					leftOffset: 18;
					rightAttachment: XmATTACHFORM;
					bottomAttachment: XmATTACHFORM ].
				
			radioBox setSensitive: isEnabled ].
		isFirstCategory := false ]
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
AISettingsSectionFunctions >> radioButtonAlwaysValueChanged: radioButton clientData: function callData: callData [

	callData set ifTrue: [
		functionsSet dontRequirePermissionToCallFunction: function ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionFunctions >> radioButtonAskValueChanged: radioButton clientData: function callData: callData [

	callData set ifTrue: [
		functionsSet requirePermissionToCallFunction: function ]
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

	resetButton setSensitive: false.
	[
		[
			AIFunctionsSet resetCurrent
		] ensure: [
			CwAppContext default syncExecInUI: [
				resetButton setSensitive: true ] ]
	] fork
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
	(#(current functions functionsRequiringPermission) includes: aspect) ifTrue: [
		| oldRowColumn |
		oldRowColumn := functionsRowColumn.
		self createFunctionsRowColumn.
		functionsRowColumn manageChild.
		oldRowColumn destroyWidget ].
]
