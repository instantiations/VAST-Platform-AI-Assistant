Class {
	#name : 'AICodeMergeWindow',
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
	#category : 'AIAssistantMergeViewApp'
}

{ #category : 'Internal' }
AICodeMergeWindow class >> desiredWindowSize [
	"Answer the desired window size."

	^self windowRatio * (700 @ 500)
]

{ #category : 'Internal' }
AICodeMergeWindow class >> openOn: leftStr and: rightStr forClass: aClass selector: aSelector [
	"Open a new comparison view with the provided strings for the given class and selector."

	| view |
	view := self new.
	view leftString: leftStr.
	view rightString: rightStr.
	view theClass: aClass theSelector: aSelector.
	view open.
	^view
]

{ #category : 'Internal' }
AICodeMergeWindow >> alignEditors [
	"Inject empty annotations based on the padding calculated by the comparer, with a light grey background."

	comparer ifNil: [^self].
	
	leftEditor annotationClearAll.
	rightEditor annotationClearAll.
	
	"1 = ANNOTATION_STANDARD"
	leftEditor annotationSetVisible: 1.
	rightEditor annotationSetVisible: 1.

	comparer leftPaddings keysAndValuesDo: [:line :count |
		| padding |
		padding := WriteStream on: String new.
		
		"Scintilla annotations consume exactly the number of lines corresponding 
		 to the number of newlines in the string PLUS ONE for the text itself.
		 Therefore, to consume N lines of padding, the string must contain exactly 
		 N - 1 newlines!"
		1 to: (count - 1 max: 0) do: [:i | padding nextPut: Character lf].
		padding nextPut: $ .
		
		leftEditor annotationSetText: (line - 1 max: 0) text: padding contents.
		leftEditor annotationSetStyle: (line - 1 max: 0) style: 51.
	].

	comparer rightPaddings keysAndValuesDo: [:line :count |
		| padding |
		padding := WriteStream on: String new.
		1 to: (count - 1 max: 0) do: [:i | padding nextPut: Character lf].
		padding nextPut: $ .
		
		rightEditor annotationSetText: (line - 1 max: 0) text: padding contents.
		rightEditor annotationSetStyle: (line - 1 max: 0) style: 51.
	].
]

{ #category : 'Actions' }
AICodeMergeWindow >> cancel [
	"Close the window."

	self close
]

{ #category : 'Internal' }
AICodeMergeWindow >> compilerError: error [
	"Report a compiler error to the user."

	| errorPos |
	errorPos := error startPosition - 1 max: 0.
	
	rightEditor
		setReadonly: false;
		setInputFocus;
		insertAndShow: errorPos value: error message;
		setSelection: errorPos @ (errorPos + error message size);
		setReadonly: true
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AICodeMergeWindow >> createWorkRegion [
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

{ #category : 'Internal',
  #vaVisibility : 'private' }
AICodeMergeWindow >> highlightAllDifferences [
	"Highlight all unequal runs in red/green (full line) and red/green (characters)."
	
	"Indicator 0 is Red (Removed characters), Indicator 1 is Green (Added characters)"
	leftEditor indicatorSetCurrent: 0.
	rightEditor indicatorSetCurrent: 1.
	
	"1. Apply background styles to full lines"
	comparer unEqualRuns do: [:runLines | 	| runChars |
		runChars := comparer convertRunToCharacterLocations: runLines.
		"Left Editor (Removed lines -> Marker 1 Light Red)"
		self markerRange: (runChars at: 1) x to: (runChars at: 2) x on: leftEditor markerNumber: 1.
		"Right Editor (Added lines -> Marker 2 Light Green)"
		self markerRange: (runChars at: 1) y to: (runChars at: 2) y on: rightEditor markerNumber: 2.
	].

	"2. Apply Red indicator to removed characters"
	comparer deletedCharRuns do: [:charRuns | 
		self indicatorRange: (charRuns at: 1) x to: (charRuns at: 2) x on: leftEditor.
	].

	"3. Apply Green indicator to added characters"
	comparer insertedCharRuns do: [:charRuns | 
		self indicatorRange: (charRuns at: 1) y to: (charRuns at: 2) y on: rightEditor.
	].
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AICodeMergeWindow >> includeEditMenu [

	^ false
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AICodeMergeWindow >> includeFileMenu [

	^ false
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AICodeMergeWindow >> indicatorRange: startChar to: endChar on: editor [
	"Apply the currently selected indicator to the character range."

	| start len |
	start := (startChar - 1) max: 0.
	len := (endChar - startChar) max: 0.
	
	len > 0 ifTrue: [
		editor indicatorFillRange: start fillLength: len.
	].
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AICodeMergeWindow >> initializeAfterRealize [
	"The widgets are now fully created. Populate them with initial data."

	super initializeAfterRealize.

	"1. Apply Smalltalk syntax highlighting first"
	leftEditor lexerSmalltalk.
	rightEditor lexerSmalltalk.

	"2. Clear previous styling so the lexer can take over correctly"
	leftEditor clearDocumentStyle.
	rightEditor clearDocumentStyle.

	"3. Set initial strings"
	leftString notNil ifTrue: [ leftEditor setText: leftString asString ].
	rightString notNil ifTrue: [ rightEditor setText: rightString asString ].

	"4. Do the comparison and apply marker styling"
	self initializeComparer.
	self initializeStyles.
	self highlightAllDifferences.
	self alignEditors.
	
	"5. Make editors read-only"
	leftEditor setReadonly: true.
	rightEditor setReadonly: true.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AICodeMergeWindow >> initializeComparer [
	"Initialize the comparer with the text from our editors."

	comparer := AIDMPStringComparer new
		string1: leftEditor getString;
		string2: rightEditor getString;
		compare;
		yourself.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AICodeMergeWindow >> initializeStyles [

	self setupStylesFor: leftEditor.
	self setupStylesFor: rightEditor.
	self setupIndicatorsFor: leftEditor.
	self setupIndicatorsFor: rightEditor.
]

{ #category : 'Internal' }
AICodeMergeWindow >> label [
	"Return the window title."

	^theSelector ifNil: [ 'Class MergeView' ] ifNotNil: [ 'Method MergeView' ]
]

{ #category : 'Initialization' }
AICodeMergeWindow >> leftString: aString [
	"Store the left string to be displayed later."

	leftString := aString
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AICodeMergeWindow >> markerRange: startChar to: endChar on: editor markerNumber: markerNumber [
	"Add a line marker to the lines covering the character range."

	| startLine endLine len start |
	start := (startChar - 1) max: 0.
	len := (endChar - startChar) max: 0.
	
	len > 0 ifTrue: [
		startLine := editor lineFromPosition: start.
		endLine := editor lineFromPosition: start + len - 1.
		startLine to: endLine do: [:line |
			editor markerAdd: line markerNumber: markerNumber
		].
	].
]

{ #category : 'Actions' }
AICodeMergeWindow >> merge [
	"Compile the new method or class definition source."

	| newSource result |
	newSource := rightEditor getText.
	
	"When theSelector is nil, we have a class definition."
	theSelector ifNil: [
		Compiler evaluate: newSource for: nil ifFail: [ :error |
			self compilerError: error.
			^self ].
		self close.
		^self ].

	result := theClass compile: newSource notifying: self.
	result ifNotNil: [ self close ]
]

{ #category : 'Initialization' }
AICodeMergeWindow >> rightString: aString [
	"Store the right string to be displayed later."

	rightString := aString
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AICodeMergeWindow >> scNotification: aWidget clientData: anObject callData: aCallData [
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

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AICodeMergeWindow >> setupIndicatorsFor: anEditor [
	"Configure indicator 0 (red) for removed characters and 1 (green) for added characters."

	"8 is the constant for INDIC_STRAIGHTBOX"
	
	"Configure Indicator 0: Removed (Red)"
	anEditor indicatorSetStyle: 0 style: 8. 
	anEditor indicatorSetFore: 0 color: 16r0000FF. "BBGGRR"
	anEditor indicatorSetAlpha: 0 alpha: 60. 
	anEditor indicatorSetOutlineAlpha: 0 alpha: 100. 
	anEditor indicatorSetUnder: 0 under: 1.

	"Configure Indicator 1: Added (Green)"
	anEditor indicatorSetStyle: 1 style: 8. 
	anEditor indicatorSetFore: 1 color: 16r00AA00. "BBGGRR - slightly darker green"
	anEditor indicatorSetAlpha: 1 alpha: 60. 
	anEditor indicatorSetOutlineAlpha: 1 alpha: 100. 
	anEditor indicatorSetUnder: 1 under: 1.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AICodeMergeWindow >> setupStylesFor: anEditor [
	"Configure styles for diff lines and light grey padding backgrounds."

	"Marker 1 (Light Red) for Left Editor (Removed)"
	anEditor markerDefine: 1 markerSymbol: 22. "SC_MARK_BACKGROUND"
	anEditor markerSetBack: 1 colour: 16rEAEAFE. "BBGGRR format"

	"Marker 2 (Light Green) for Right Editor (Added)"
	anEditor markerDefine: 2 markerSymbol: 22. "SC_MARK_BACKGROUND"
	anEditor markerSetBack: 2 colour: 16rDDF0E6. "BBGGRR format"
		
	"Style 51 (Very Light Grey) for Padding lines"
	anEditor 
		styleSetBack: 51 color: 16rF5F5F5; "BBGGRR format"
		styleSetEolFilled: 51 value: true.
]

{ #category : 'Initialization' }
AICodeMergeWindow >> theClass: aClass theSelector: aSelector [
	"Set the class and selector for the method being compared."

	theClass := aClass.
	theSelector := aSelector
]
