Class {
	#name : 'AIChatWidgetTargetTextWidgetAdapter',
	#superclass : 'Object',
	#instVars : [
		'chatWidget'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter class >> for: chatWidget [

	^ self basicNew initializeWithChatWidget: chatWidget
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> copySelection [

	self getSelection ifNotNil: [ :selectedString |
		selectedString copyToClipboard ]
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> cursorPosition [

	^ 0
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> getSelection [

	^ self getString ifEmpty: [ nil ]
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> getSelectionPosition [

	^ self getSelection ifNil: [ 0@0 ] ifNotNil: [ :string | 0 @ string size ]
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> getString [

	^ chatWidget selectedString asEsString ifNil: [ '' ]
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> initializeWithChatWidget: initialChatWidget [

	self initialize.
	chatWidget := initialChatWidget.
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> insertAndShow: errorPosition value: errorMessage [

	| linesSize maxLineSize shell form textWidget okButton |

	linesSize := 0.
	maxLineSize := 0.
	self getString linesDo: [ :line |
		linesSize := linesSize + 1.
		maxLineSize := maxLineSize max: line size ].
	
	shell := CwTopLevelShell createApplicationShell: 'Evaluation Failed' argBlock: [ :w |
		w width: 400 * ((maxLineSize / 50 max: 1) min: 2); height: 250 * ((linesSize / 10 max: 1) min: 2) ].
	(form := shell createForm: nil argBlock: nil)
		manageChild.		
	textWidget := (form createScrolledText: 'text' argBlock: [ :w | w editMode: CwConstants::XmMULTILINEEDIT ])
		manageChild;
		editable: false;
		value: self getString.
	(okButton := form createPushButton: 'OK' argBlock: nil)
		manageChild;
		addCallback: CwConstants::XmNactivateCallback receiver: shell selector: #destroyWidget clientData: nil.

	textWidget parent setValuesBlock: [ :w |
		w topAttachment: CwConstants::XmATTACHFORM;
			leftAttachment: CwConstants::XmATTACHFORM;
			rightAttachment: CwConstants::XmATTACHFORM;
			bottomAttachment: CwConstants::XmATTACHWIDGET;
			bottomWidget: okButton;
			bottomOffset: 5 ].
	okButton setValuesBlock: [ :w |
		w 
			bottomAttachment: CwConstants::XmATTACHFORM;
			bottomOffset: 5;
			rightAttachment: CwConstants::XmATTACHFORM;
			rightOffset: 5 ].
	shell realizeWidget.

	textWidget
		insertAndShow: errorPosition value: errorMessage;
		setSelection: errorPosition @ (errorPosition + errorMessage size).
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> isDestroyed [

	^ true
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> setSelection: positions [

	"Ignored"
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> stsPossibleSelector: shouldAdjust for: window ifNone: block [

	^ nil
]

{ #category : 'Not categorized' }
AIChatWidgetTargetTextWidgetAdapter >> stsResolveSelectionAsSelector: aSymbol [

	| namespace |

	aSymbol isEmpty ifTrue: [^false].
	(StsPowerTools methodSelectorExists: aSymbol) ifFalse: [^false].
	(aSymbol includes: $:) ifTrue: [^true].
	aSymbol first isLowercase ifTrue: [^true].
	namespace := System globalNamespace.
	(namespace includesKey: aSymbol) ifTrue: [^false].
	^true
]
