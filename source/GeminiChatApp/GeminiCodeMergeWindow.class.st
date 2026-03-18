Class {
	#name : 'GeminiCodeMergeWindow',
	#superclass : 'EtWindow',
	#instVars : [
		'leftEditor',
		'rightEditor',
		'leftString',
		'rightString',
		'comparer',
		'leftScroll',
		'rightScroll',
		'oll',
		'theClass',
		'theSelector',
		'isScrolling'
	],
	#pools : [
		'ScintillaConstants'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiCodeMergeWindow class >> desiredWindowSize [
	"Answer the desired window size."

	^self windowRatio * (700 @ 600)
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow class >> open [
	"Open an instance of the receiver as a windowed part.
	<script>"

	^self new open
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow class >> openOn: leftStr and: rightStr forClass: aClass selector: aSelector [
	"Open a new comparison view with the provided strings for the given class and selector."

	| view |
	view := self new.
	view leftString: leftStr.
	view rightString: rightStr.
	view theClass: aClass theSelector: aSelector.
	view open.
	^view
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> cancel [
	"Close the window."

	self close
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> createWorkRegion [
	"Create and lay out the subparts for the comparison view."

	| sash mergeButton cancelButton |
	sash := self newSash: XmVERTICAL.

	leftEditor := (CwScintillaEditor
		createWidget: 'leftEditor'
		parent: self defaultWidgetParent
		argBlock: [:w | ]) manageChild.
	leftEditor
		addCallback: XmNnotificationCallback
		receiver: self
		selector: #scNotification:clientData:callData:
		clientData: nil.

	rightEditor := (CwScintillaEditor
		createWidget: 'rightEditor'
		parent: self defaultWidgetParent
		argBlock: [:w | ]) manageChild.
	rightEditor
		addCallback: XmNnotificationCallback
		receiver: self
		selector: #scNotification:clientData:callData:
		clientData: nil.

	mergeButton := (self defaultWidgetParent
		createPushButton: 'Merge'
		argBlock: [ :w |
			w
				labelString: 'Merge';
				addCallback: XmNactivateCallback
					receiver: self
					selector: #merge
					clientData: nil]) manageChild.

	cancelButton := (self defaultWidgetParent
		createPushButton: 'Cancel'
		argBlock: [ :w |
			w
				labelString: 'Cancel';
				addCallback: XmNactivateCallback
					receiver: self
					selector: #cancel
					clientData: nil]) manageChild.

	sash setValuesBlock: [:w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHPOSITION;
			leftPosition: 50;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 35].

	leftEditor setValuesBlock: [:w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: sash;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 35].

	rightEditor setValuesBlock: [:w |
		w
			topAttachment: XmATTACHFORM;
			leftAttachment: XmATTACHWIDGET;
			leftWidget: sash;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 35].

	mergeButton setValuesBlock: [:w |
		w
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 5;
			rightAttachment: XmATTACHFORM;
			rightOffset: 5].

	cancelButton setValuesBlock: [:w |
		w
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 5;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: mergeButton;
			rightOffset: 5]
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> highlightAllDifferences [
	"Highlight all unequal runs in orange and equal runs in green in both editors."

	| unequalRuns equalRuns runChars |
	comparer ifNil: [^self].
	
	self setupIndicatorsFor: leftEditor.
	self setupIndicatorsFor: rightEditor.
	
	"1. Highlight Differences (Indicator 0)"
	leftEditor indicatorSetCurrent: 0.
	rightEditor indicatorSetCurrent: 0.
	
	unequalRuns := comparer unEqualRuns.
	unequalRuns do: [:runLines | 
		runChars := comparer convertRunToCharacterLocations: runLines.
		self highlightRange: (runChars at: 1) x to: (runChars at: 2) x on: leftEditor.
		self highlightRange: (runChars at: 1) y to: (runChars at: 2) y on: rightEditor.
	].

	"2. Highlight Matches (Indicator 1)"
	leftEditor indicatorSetCurrent: 1.
	rightEditor indicatorSetCurrent: 1.
	
	equalRuns := comparer equalRuns.
	equalRuns do: [:runLines | 
		runChars := comparer convertRunToCharacterLocations: runLines.
		self highlightRange: (runChars at: 1) x to: (runChars at: 2) x on: leftEditor.
		self highlightRange: (runChars at: 1) y to: (runChars at: 2) y on: rightEditor.
	].
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> highlightRange: startChar to: endChar on: editor [
	"Apply the currently selected indicator to the character range."

	| start len |
	"Convert from 1-based Smalltalk string indexes to 0-based Scintilla indexes"
	start := (startChar - 1) max: 0.
	len := (endChar - startChar) max: 0.
	
	len > 0 ifTrue: [
		editor indicatorFillRange: start fillLength: len.
	].
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> initializeAfterRealize [
	"The widgets are now fully created. Populate them with initial data."

	super initializeAfterRealize.

	leftString notNil ifTrue: [ leftEditor setText: leftString asString ].
	rightString notNil ifTrue: [ rightEditor setText: rightString asString ].

	self initializeComparer.
	self highlightAllDifferences.
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> initializeComparer [
	"Initialize the comparer with the text from our editors."

	comparer := EtStringComparer new
		string1: leftEditor getString;
		string2: rightEditor getString;
		compare;
		yourself.
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> label [
	"Return the window title."

	^'Method MergeView'
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> leftString: aString [
	"Store the left string to be displayed later."

	leftString := aString
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> merge [
	"Compile the new method source."

	| newSource |
	newSource := rightEditor getText.
	theClass compile: newSource.
	self close
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> rightString: aString [
	"Store the right string to be displayed later."

	rightString := aString
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> scNotification: aWidget clientData: anObject callData: aCallData [
	"Callback to synchronize scrolling between the two editors."

	| sourceEditor targetEditor firstLine |
	isScrolling == true ifTrue: [^self]. "Prevent infinite loop"

	aCallData code = SCN_UPDATEUI
		ifTrue:
			[isScrolling := true.
			sourceEditor := aWidget.
			targetEditor := sourceEditor == leftEditor ifTrue: [rightEditor] ifFalse: [leftEditor].

			firstLine := sourceEditor getFirstVisibleLine.
			targetEditor setFirstVisibleLine: firstLine.
			isScrolling := false]
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> setupIndicatorsFor: anEditor [
	"Configure indicator 0 (orange) for differences and 1 (green) for matches."

	"8 is the constant for INDIC_STRAIGHTBOX"
	
	"Configure Indicator 0: Differences (Orange)"
	anEditor indicatorSetStyle: 0 style: 8. 
	anEditor indicatorSetFore: 0 color: 16r00A5FF. "Color is BBGGRR in Scintilla"
	anEditor indicatorSetAlpha: 0 alpha: 40. 
	anEditor indicatorSetOutlineAlpha: 0 alpha: 100. 
	anEditor indicatorSetUnder: 0 under: 1.

	"Configure Indicator 1: Matches (Green)"
	anEditor indicatorSetStyle: 1 style: 8. 
	anEditor indicatorSetFore: 1 color: 16r00FF00. 
	anEditor indicatorSetAlpha: 1 alpha: 40. 
	anEditor indicatorSetOutlineAlpha: 1 alpha: 100. 
	anEditor indicatorSetUnder: 1 under: 1.
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> theClass: aClass theSelector: aSelector [
	"Set the class and selector for the method being compared."

	theClass := aClass.
	theSelector := aSelector
]
