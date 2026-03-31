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
GeminiCodeMergeWindow >> alignEditors [
	"Inject empty annotations based on the padding calculated by the comparer."

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
	].

	comparer rightPaddings keysAndValuesDo: [:line :count |
		| padding |
		padding := WriteStream on: String new.
		1 to: (count - 1 max: 0) do: [:i | padding nextPut: Character lf].
		padding nextPut: $ .
		
		rightEditor annotationSetText: (line - 1 max: 0) text: padding contents.
	].
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> cancel [
	"Close the window."

	self close
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> compilerError: error [
	"Report a compiler error to the user."

	| errorPos |
	errorPos := error startPosition - 1 max: 0.
	rightEditor
		setInputFocus;
		insertAndShow: errorPos value: error message;
		setSelection: errorPos @ (errorPos + error message size)
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
	"Highlight line changes in light colors, and intra-line changes in darker colors."

	| runChars |
	comparer ifNil: [^self].
	
	self setupIndicatorsFor: leftEditor.
	self setupIndicatorsFor: rightEditor.
	
	"1. Full-line Deletions (Light Red)"
	leftEditor indicatorSetCurrent: 0.
	comparer deletedRuns do: [:runLines | 
		runChars := comparer convertRunToCharacterLocations: runLines.
		self highlightRange: (runChars at: 1) x to: (runChars at: 2) x on: leftEditor.
	].

	"2. Full-line Insertions (Light Green)"
	rightEditor indicatorSetCurrent: 1.
	comparer insertedRuns do: [:runLines | 
		runChars := comparer convertRunToCharacterLocations: runLines.
		self highlightRange: (runChars at: 1) y to: (runChars at: 2) y on: rightEditor.
	].
	
	"3. Character-level Deletions (Dark Red)"
	leftEditor indicatorSetCurrent: 2.
	comparer deletedCharRuns do: [:runLines | 
		runChars := comparer convertRunToCharacterLocations: runLines.
		self highlightRange: (runChars at: 1) x to: (runChars at: 2) x on: leftEditor.
	].

	"4. Character-level Insertions (Dark Green)"
	rightEditor indicatorSetCurrent: 3.
	comparer insertedCharRuns do: [:runLines | 
		runChars := comparer convertRunToCharacterLocations: runLines.
		self highlightRange: (runChars at: 1) y to: (runChars at: 2) y on: rightEditor.
	].
	
	self alignEditors.
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

	comparer := EtDMPStringComparer new
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

	| newSource result |
	newSource := rightEditor getText.
	result := theClass compile: newSource notifying: self.
	result ifNotNil: [ self close ]
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
	"Configure indicators for line and character diffs."

	"8 is the constant for INDIC_STRAIGHTBOX"
	
	"Indicator 0: Line Deletions (Light Red)"
	anEditor indicatorSetStyle: 0 style: 8. 
	anEditor indicatorSetFore: 0 color: 16r0000FF. 
	anEditor indicatorSetAlpha: 0 alpha: 25. 
	anEditor indicatorSetUnder: 0 under: 1.

	"Indicator 1: Line Insertions (Light Green)"
	anEditor indicatorSetStyle: 1 style: 8. 
	anEditor indicatorSetFore: 1 color: 16r00FF00. 
	anEditor indicatorSetAlpha: 1 alpha: 25. 
	anEditor indicatorSetUnder: 1 under: 1.

	"Indicator 2: Char Deletions (Dark Red)"
	anEditor indicatorSetStyle: 2 style: 8. 
	anEditor indicatorSetFore: 2 color: 16r0000FF. 
	anEditor indicatorSetAlpha: 2 alpha: 100. 
	anEditor indicatorSetUnder: 2 under: 1.

	"Indicator 3: Char Insertions (Dark Green)"
	anEditor indicatorSetStyle: 3 style: 8. 
	anEditor indicatorSetFore: 3 color: 16r00FF00. 
	anEditor indicatorSetAlpha: 3 alpha: 100. 
	anEditor indicatorSetUnder: 3 under: 1.
]

{ #category : 'Not categorized' }
GeminiCodeMergeWindow >> theClass: aClass theSelector: aSelector [
	"Set the class and selector for the method being compared."

	theClass := aClass.
	theSelector := aSelector
]
