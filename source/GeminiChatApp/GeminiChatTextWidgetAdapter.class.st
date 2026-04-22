Class {
	#name : 'GeminiChatTextWidgetAdapter',
	#superclass : 'Object',
	#instVars : [
		'chatWidget'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter class >> for: chatWidget [

	^ self basicNew initializeWithChatWidget: chatWidget
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> copySelection [

	self getSelection ifNotNil: [ :selectedString |
		selectedString copyToClipboard ]
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> cursorPosition [

	^ 0
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> getSelection [

	^ self getString ifEmpty: [ nil ]
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> getSelectionPosition [

	^ self getSelection ifNil: [ 0@0 ] ifNotNil: [ :string | 0 @ string size ]
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> getString [

	^ chatWidget selectedString asEsString ifNil: [ '' ]
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> initializeWithChatWidget: initialChatWidget [

	self initialize.
	chatWidget := initialChatWidget.
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> insertAndShow: errorPosition value: errorMessage [

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
GeminiChatTextWidgetAdapter >> isDestroyed [

	^ true
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> setSelection: positions [

	"Ignored"
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> stsPossibleSelector: shouldAdjust for: window ifNone: block [

	^ nil
]

{ #category : 'Not categorized' }
GeminiChatTextWidgetAdapter >> stsResolveSelectionAsSelector: aSymbol [

	| namespace |

	aSymbol isEmpty ifTrue: [^false].
	(StsPowerTools methodSelectorExists: aSymbol) ifFalse: [^false].
	(aSymbol includes: $:) ifTrue: [^true].
	aSymbol first isLowercase ifTrue: [^true].
	namespace := System globalNamespace.
	(namespace includesKey: aSymbol) ifTrue: [^false].
	^true
]
