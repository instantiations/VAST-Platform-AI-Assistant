Class {
	#name : 'AISettingsSectionSystemInstruction',
	#superclass : 'AIAbstractSettingsSection',
	#instVars : [
		'radioButtonDefault',
		'radioButtonCustom',
		'text'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AISettingsSectionSystemInstruction >> closeWindow [

	^ true
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> createSettingsPane: settingsForm [

	| form radioBox |

	form := settingsForm createForm: nil argBlock: nil.

	(radioBox := form createRadioBox: nil argBlock: [ :w | w orientation: XmHORIZONTAL ])
		manageChild.
	(radioButtonDefault := radioBox createToggleButton: nil argBlock: [ :w | w labelString: 'Default' ])
		manageChild.
	(radioButtonCustom := radioBox createToggleButton: nil argBlock: [ :w | w labelString: 'Custom' ])
		manageChild;
		addCallback: XmNvalueChangedCallback
			receiver: self
			selector: #radioButtonCustomValueChanged:clientData:callData:
			clientData: nil.
	(text := form createScrolledText: 'text' argBlock: [ :w | w editMode: XmMULTILINEEDIT; wordWrap: true ])
		manageChild;
		addCallback: XmNlosingFocusCallback
			receiver: self
			selector: #textLosingFocusOrActivated:clientData:callData:
			clientData: nil;
		addCallback: XmNactivateCallback
			receiver: self
			selector: #textLosingFocusOrActivated:clientData:callData:
			clientData: nil.

	form setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			rightOffset: 5;
			bottomAttachment: XmATTACHFORM ].

	radioBox setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM ].

	text parent setValuesBlock: [ :w |
		w
			topAttachment: XmATTACHWIDGET;
			topWidget: radioBox;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM ].

	self updateRadioButtons; updateText.

	^ form
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> initialize [

	super initialize.
	AIChat addDependent: self.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> radioButtonCustomValueChanged: widget clientData: clientData callData: callData [

	self for: radioButtonCustom doCallback: [
		AIChat useCustomSystemInstruction: radioButtonCustom set ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> release [

	super release.
	AIChat removeDependent: self.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> sectionChanged [

	"Do nothing"
]

{ #category : 'Not categorized' }
AISettingsSectionSystemInstruction >> sectionLabel [

	^ 'System Instruction'
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> textLosingFocusOrActivated: widget clientData: clientData callData: callData [

	self for: text doCallback: [
		(radioButtonCustom set and: [ text value ~= AIChat customSystemInstruction ]) ifTrue: [
			AIChat customSystemInstruction: text value ] ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> update: aspect [

	aspect = #useCustomSystemInstruction ifTrue: [
		self updateRadioButtons; updateText ].
	aspect = #customSystemInstruction ifTrue: [
		self updateText ].
	super update: aspect
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> updateRadioButtons [

	self noCallback: radioButtonDefault during: [ :w |
		w set: AIChat useCustomSystemInstruction not ].
	self noCallback: radioButtonCustom during: [ :w |
		w set: AIChat useCustomSystemInstruction ].
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AISettingsSectionSystemInstruction >> updateText [

	self noCallback: text during: [ :w |
		w
			editable: AIChat useCustomSystemInstruction;
			value: (AIChat useCustomSystemInstruction ifTrue: [ AIChat customSystemInstruction ] ifFalse: [ AIChat defaultSystemInstruction ]) ]
]
