Extension {
	#name : 'AISettingsSectionModels'
}

{ #category : 'User Interface',
  #vaVisibility : 'private' }
AISettingsSectionModels >> createResponsesModelDetailsOn: modelDetailsSpecific [

	| inputPosition labelOffset widgetSpacing rightMargin reasoningEffortLabel reasoningEffortCombo
	  reasoningSummaryLabel reasoningSummaryCombo temperatureLabel temperatureInput top_pLabel
	  top_pInput |

	inputPosition := 60.
	labelOffset := 2.
	widgetSpacing := 5.
	rightMargin := 10.

	reasoningEffortLabel :=
		modelDetailsSpecific
			createLabel: 'reasoningEffortLabel'
			argBlock: [:w |
				w
					labelString: 'Reasoning Effort:';
					alignment: XmALIGNMENTEND].
	reasoningEffortCombo :=
		modelDetailsSpecific
			createComboBox: 'reasoningEffortCombo'
			argBlock: [:w |
				w
					items: #('') , currentModel reasoningEffortChoices;
					addCallback: XmNsingleSelectionCallback
						receiver: self
						selector: #reasoningEffortChanged:clientData:callData:
						clientData: nil].

	reasoningSummaryLabel :=
		modelDetailsSpecific
			createLabel: 'reasoningSummaryLabel'
			argBlock: [:w |
				w
					labelString: 'Reasoning Summary:';
					alignment: XmALIGNMENTEND].
	reasoningSummaryCombo :=
		modelDetailsSpecific
			createComboBox: 'reasoningSummaryCombo'
			argBlock: [:w |
				w
					items: #('') , currentModel reasoningSummaryChoices;
					addCallback: XmNsingleSelectionCallback
						receiver: self
						selector: #reasoningSummaryChanged:clientData:callData:
						clientData: nil].

	temperatureLabel :=
		modelDetailsSpecific
			createLabel: 'temperatureLabel'
			argBlock: [:w |
				w
					labelString: 'Temperature:';
					alignment: XmALIGNMENTEND].
	temperatureInput :=
		modelDetailsSpecific
			createText: 'temperatureInput'
			argBlock: [:w |
				w
					addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #temperatureChanged:clientData:callData:
					clientData: nil].

	top_pLabel :=
		modelDetailsSpecific
			createLabel: 'top_pLabel'
			argBlock: [:w |
				w
					labelString: 'Top-p:';
					alignment: XmALIGNMENTEND].
	top_pInput :=
		modelDetailsSpecific
			createText: 'top_pInput'
			argBlock: [:w |
				w
					addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #top_pChanged:clientData:callData:
					clientData: nil].

	reasoningEffortCombo
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftPosition: inputPosition;
				topAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM;
				topOffset: widgetSpacing;
				rightOffset: rightMargin];
		manageChild;
		setString: currentModel reasoningEffort asString.
	reasoningEffortLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: reasoningEffortCombo;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: reasoningEffortCombo;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: reasoningEffortCombo;
				bottomOffset: 2];
		manageChild.

	reasoningSummaryCombo
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftPosition: inputPosition;
				topAttachment: XmATTACHWIDGET;
				topWidget: reasoningEffortCombo;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild;
		setString: currentModel reasoningSummary asString.
	reasoningSummaryLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: reasoningSummaryCombo;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: reasoningEffortCombo;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: reasoningSummaryCombo;
				bottomOffset: 2];
		manageChild.

	temperatureInput
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftPosition: inputPosition;
				topAttachment: XmATTACHWIDGET;
				topWidget: reasoningSummaryCombo;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild;
		setString: currentModel temperature asString.
	temperatureLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: temperatureInput;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: temperatureInput;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: temperatureInput;
				bottomOffset: 2];
		manageChild.

	top_pInput
		setValuesBlock: [:w |
			w
				leftAttachment: XmATTACHFORM;
				leftPosition: inputPosition;
				topAttachment: XmATTACHWIDGET;
				topWidget: temperatureInput;
				topOffset: widgetSpacing;
				rightAttachment: XmATTACHFORM;
				rightOffset: rightMargin];
		manageChild;
		setString: currentModel top_p asString.
	top_pLabel
		setValuesBlock: [:w |
			w
				topAttachment: XmATTACHOPPOSITEWIDGET;
				topWidget: top_pInput;
				rightAttachment: XmATTACHWIDGET;
				rightWidget: top_pInput;
				rightOffset: labelOffset;
				bottomAttachment: XmATTACHOPPOSITEWIDGET;
				bottomWidget: top_pInput;
				bottomOffset: 2];
		manageChild
]
