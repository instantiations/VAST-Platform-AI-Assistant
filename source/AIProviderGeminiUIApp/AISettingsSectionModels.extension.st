Extension {
	#name : 'AISettingsSectionModels'
}

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsSectionModels >> createGeminiModelDetailsOn: modelDetailsSpecific [

	| inputPosition labelOffset widgetSpacing rightMargin thinkingLevelLabel thinkingLevelCombo |

	inputPosition := 60.
	labelOffset := 2.
	widgetSpacing := 5.
	rightMargin := 10.

	thinkingLevelLabel :=
		modelDetailsSpecific
			createLabel: 'thinkingLevelLabel'
			argBlock: [:w |
				w
					labelString: 'Thinking Level:';
					alignment: XmALIGNMENTEND].
	(thinkingLevelCombo :=
		modelDetailsSpecific
			createComboBox: 'thinkingLevelCombo'
			argBlock: [:w |
				w
					items: #('default') , currentModel thinkingLevelChoices])
		addCallback: XmNsingleSelectionCallback
			receiver: self
			selector: #thinkingLevelChanged:clientData:callData:
			clientData: nil.

	thinkingLevelCombo
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftPosition: inputPosition;
				topAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				topOffset: widgetSpacing;
				rightOffset: rightMargin];
		manageChild;
		setString: (currentModel thinkingLevel ifNil: [ 'default' ]).
	thinkingLevelLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: thinkingLevelCombo;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: thinkingLevelCombo;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: thinkingLevelCombo;
				bottomOffset: 2];
		manageChild
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AISettingsSectionModels >> thinkingLevelChanged: thinkingLevelCombo clientData: clientData callData: callData [

	| thinkingLevel |

	thinkingLevel := thinkingLevelCombo getString.
	currentModel thinkingLevel: (thinkingLevel ~= 'default' ifTrue: [ thinkingLevel ]).
	self detailsChanged
]
