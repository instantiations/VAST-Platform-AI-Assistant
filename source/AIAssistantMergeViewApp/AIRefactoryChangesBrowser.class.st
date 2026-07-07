Class {
	#name : 'AIRefactoryChangesBrowser',
	#superclass : 'EtWindow',
	#instVars : [
		'changes',
		'visibleChanges',
		'showOnlyLastChanges',
		'applicationListWidget',
		'selectedApplication',
		'leftEditor',
		'rightEditor',
		'comparer',
		'leftScroll',
		'rightScroll',
		'isScrolling',
		'classNamesListWidget',
		'selectedClassname',
		'selectedChange',
		'textMenu2',
		'changesListWidget'
	],
	#pools : [
		'ScintillaConstants'
	],
	#category : 'AIAssistantMergeViewApp'
}

{ #category : 'Instance Creation' }
AIRefactoryChangesBrowser class >> openOn: aCollectionOfRefactoryChanges [
	| browser |
	browser := self new.
	browser initializeWithChanges: aCollectionOfRefactoryChanges.
	browser open.
	^browser
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> alignEditors [
	"Inject empty annotations based on the padding calculated by the comparer, with a light grey background."
	comparer ifNil: [^self].
	
	leftEditor annotationClearAll.
	rightEditor annotationClearAll.
	
	leftEditor annotationSetVisible: ANNOTATION_STANDARD.
	rightEditor annotationSetVisible: ANNOTATION_STANDARD.

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
		leftEditor annotationSetStyle: (line - 1 max: 0) style: self paddingStyle.
	].

	comparer rightPaddings keysAndValuesDo: [:line :count |
		| padding |
		padding := WriteStream on: String new.
		1 to: (count - 1 max: 0) do: [:i | padding nextPut: Character lf].
		padding nextPut: $ .
		
		rightEditor annotationSetText: (line - 1 max: 0) text: padding contents.
		rightEditor annotationSetStyle: (line - 1 max: 0) style: self paddingStyle.
	].
]

{ #category : 'Actions' }
AIRefactoryChangesBrowser >> applicationSelected: selectedItem [

	| classNames |

	selectedApplication := selectedItem.
	classNames := self classNames.
	classNamesListWidget items: classNames.

	classNames notEmpty
		ifTrue: [self restoreSelection: selectedClassname in: classNamesListWidget items: classNames]
		ifFalse: [
			selectedChange := nil.
			changesListWidget deleteAllItems]
]

{ #category : 'Accessing' }
AIRefactoryChangesBrowser >> applications [

	^(visibleChanges collect: [:each | each application]) asSet
		asSortedCollection: [:a :b | a name <= b name]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> baseClassNameFor: aClassDisplayName [

	aClassDisplayName ifNil: [^nil].
	^aClassDisplayName copyUpTo: Character space
]

{ #category : 'Toolbar' }
AIRefactoryChangesBrowser >> browseHierarchy [
	| selectedClass |
	
	selectedClass := selectedClassname ifNotNil: [:n | Smalltalk at: (self baseClassNameFor: n) asSymbol ifAbsent: [ nil ]].
	selectedClass ifNotNil:[
		self execShortOperation: [
			((self browser: #classes) on: selectedClass) 
				owningImage: self owningImage;  
				open]]
]

{ #category : 'Actions' }
AIRefactoryChangesBrowser >> cancel [
	self close
]

{ #category : 'Actions' }
AIRefactoryChangesBrowser >> changeSelected: selectedChangeObject [

	"If nothing is selected, gracefully fallback to show the class change, if any."
	selectedChangeObject isNil ifTrue: [^self showEmptyEditors].

	selectedChange := selectedChangeObject.
	selectedChange displayInMergeBrowser: self
]

{ #category : 'Accessing' }
AIRefactoryChangesBrowser >> changesForClass [

	| changesForSelected |
	selectedClassname ifNil: [^OrderedCollection new].
	changesForSelected := visibleChanges select: [:each |
		each application = selectedApplication
			and: [each displayClassName = selectedClassname]].
	^(changesForSelected asSortedCollection: [:a :b | a sortPriorityAgainst: b]) asOrderedCollection
]

{ #category : 'Accessing' }
AIRefactoryChangesBrowser >> classNames [

	| changesForApp |

	selectedApplication ifNil: [^OrderedCollection new].
	changesForApp := visibleChanges select: [:each | each application = selectedApplication].
	^(changesForApp collect: [:each | each displayClassName]) asSet asSortedCollection
]

{ #category : 'Toolbar' }
AIRefactoryChangesBrowser >> classReferences [

	selectedClassname
		ifNotNil: [:n | self owningImage allMethodsReferencingLiteral: (self baseClassNameFor: n) asSymbol]
]

{ #category : 'Actions' }
AIRefactoryChangesBrowser >> classnameSelected: selectedItem [

	| changesToShow previousChange |

	previousChange := selectedChange.
	selectedChange := nil.
	selectedClassname := selectedItem.

	changesToShow := self changesForClass.
	changesListWidget items: changesToShow.
	changesToShow notEmpty
		ifTrue: [self restoreSelection: previousChange in: changesListWidget items: changesToShow]
		ifFalse: [changesListWidget deselectAllItems]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> createDiffRegionUnder: aTopWidget [
	| sash mergeButton cancelButton discardButton showOnlyLastChangesCheckbox topAttachment |
	sash := self newSash: XmVERTICAL.

	leftEditor := (StsScintillaEditor
		createWidget: 'leftEditor'
		parent: self defaultWidgetParent
		argBlock: [:w | self stsSetFontListFor: w]) manageChild.
	leftEditor usePopup: false.
	leftEditor
		addCallback: XmNnotificationCallback
		receiver: self
		selector: #scNotification:clientData:callData:
		clientData: nil.
	leftEditor menu: self textMenu owner: self.
	self addTargetTextWidgetCallbacks: leftEditor.

	rightEditor := (StsScintillaEditor
		createWidget: 'rightEditor'
		parent: self defaultWidgetParent
		argBlock: [:w | self stsSetFontListFor: w]) manageChild.
	rightEditor usePopup: false.
	rightEditor
		addCallback: XmNnotificationCallback
		receiver: self
		selector: #scNotification:clientData:callData:
		clientData: nil.
	rightEditor menu: self textMenu2 owner: self.
	self addTargetTextWidgetCallbacks: rightEditor.

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

	discardButton := (self defaultWidgetParent
		createPushButton: 'Discard'
		argBlock: [ :w |
			w
				labelString: 'Discard';
				addCallback: XmNactivateCallback
					receiver: self
					selector: #discard
					clientData: nil]) manageChild.

	showOnlyLastChangesCheckbox := (self defaultWidgetParent
		createToggleButton: 'showOnlyLastChanges'
		argBlock: [ :w |
			w
				labelString: 'Show only last changes';
				set: showOnlyLastChanges;
				addCallback: XmNvalueChangedCallback
					receiver: self
					selector: #showOnlyLastChangesChanged:clientData:callData:
					clientData: nil]) manageChild.

	topAttachment := aTopWidget ifNil: [ XmATTACHFORM ] ifNotNil: [ XmATTACHWIDGET ].

	sash setValuesBlock: [:w |
		w
			topAttachment: topAttachment;
			topWidget: aTopWidget;
			leftAttachment: XmATTACHPOSITION;
			leftPosition: 50;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 35].

	leftEditor setValuesBlock: [:w |
		w
			topAttachment: topAttachment;
			topWidget: aTopWidget;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: sash;
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 35].

	rightEditor setValuesBlock: [:w |
		w
			topAttachment: topAttachment;
			topWidget: aTopWidget;
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
			rightOffset: 5].

	discardButton setValuesBlock: [:w |
		w
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 5;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: cancelButton;
			rightOffset: 5].

	showOnlyLastChangesCheckbox setValuesBlock: [:w |
		w
			bottomAttachment: XmATTACHFORM;
			bottomOffset: 5;
			leftAttachment: XmATTACHFORM;
			leftOffset: 5].
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> createWorkRegion [
	| topHorizontalSash middleVerticalSash1 middleVerticalSash2 toolBar |
	
	toolBar := self stsToolBar.

	topHorizontalSash := self newSash: XmHORIZONTAL.
	middleVerticalSash1 := self newSash: XmVERTICAL.
	middleVerticalSash2 := self newSash: XmVERTICAL.

	applicationListWidget := self 
		newListWidget: #applications
		changeSelector: #applicationSelected:
		printBlock: [:app | app name]
		statusBlock: nil
		initialSelection: nil
		returnItems: true.
	
	classNamesListWidget := self 
		newListWidget: #classNames
		changeSelector: #classnameSelected:
		printBlock: [:cls | cls ]
		statusBlock: nil
		initialSelection: nil
		returnItems: true.

	changesListWidget := self 
		newListWidget: #changesForClass
		changeSelector: #changeSelected:
		printBlock: [:m | m listviewDisplayString ]
		statusBlock: nil
		initialSelection: nil
		returnItems: true.

	toolBar notNil
		ifTrue: [
			toolBar setValuesBlock: [:w |
				w
					topAttachment: XmATTACHFORM;
					leftAttachment: XmATTACHFORM;
					rightAttachment: XmATTACHFORM]].

	topHorizontalSash setValuesBlock: [:w |
		w
			topAttachment: XmATTACHPOSITION;
			topPosition: 30;
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM ].

	"First sash at 33%"
	middleVerticalSash1 setValuesBlock: [:w |
		toolBar isNil
			ifTrue: [w topAttachment: XmATTACHFORM]
			ifFalse: [
				w
					topAttachment: XmATTACHWIDGET;
					topWidget: toolBar].
		w
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: topHorizontalSash;
			leftAttachment: XmATTACHPOSITION;
			leftPosition: 33 ].

	"Second sash at 66%"
	middleVerticalSash2 setValuesBlock: [:w |
		toolBar isNil
			ifTrue: [w topAttachment: XmATTACHFORM]
			ifFalse: [
				w
					topAttachment: XmATTACHWIDGET;
					topWidget: toolBar].
		w
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: topHorizontalSash;
			leftAttachment: XmATTACHPOSITION;
			leftPosition: 66 ].

	applicationListWidget parent setValuesBlock: [:w |
		toolBar isNil
			ifTrue: [w topAttachment: XmATTACHFORM]
			ifFalse: [
				w
					topAttachment: XmATTACHWIDGET;
					topWidget: toolBar].
		w
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: middleVerticalSash1;
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: topHorizontalSash ].

	classNamesListWidget parent setValuesBlock: [:w |
		toolBar isNil
			ifTrue: [w topAttachment: XmATTACHFORM]
			ifFalse: [
				w
					topAttachment: XmATTACHWIDGET;
					topWidget: toolBar].
		w
			leftAttachment: XmATTACHWIDGET;
			leftWidget: middleVerticalSash1;
			rightAttachment: XmATTACHWIDGET;
			rightWidget: middleVerticalSash2;
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: topHorizontalSash ].

	changesListWidget parent setValuesBlock: [:w |
		toolBar isNil
			ifTrue: [w topAttachment: XmATTACHFORM]
			ifFalse: [
				w
					topAttachment: XmATTACHWIDGET;
					topWidget: toolBar].
		w
			leftAttachment: XmATTACHWIDGET;
			leftWidget: middleVerticalSash2;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHWIDGET;
			bottomWidget: topHorizontalSash ].

	self createDiffRegionUnder: topHorizontalSash
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> deduplicateChanges: anOrderedCollection [
	"A common behavior with LLMs when using tools, especially for code generation is that they will call the tool again for the same code entity when they want to 'correct' previous calls. 
	 When this is done in a single model response, it does not make sense to present the user with those intermediate calls, we adopt a 'last change wins' strategy."

	| deduplicatedChanges keysSeen |
	deduplicatedChanges := OrderedCollection new.
	keysSeen := Set new.
	anOrderedCollection reverseDo: [:change | | key |
		key := change entityRepresentationKey.
		(keysSeen includes: key) ifFalse: [
			keysSeen add: key.
			deduplicatedChanges addFirst: change ]].
	^ deduplicatedChanges
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> defaultTextMenu [
	"Allows any SubApplication to customize the menus of the merge view."

	| aMenu orderedApps |
	aMenu := super defaultTextMenu.
	orderedApps := OrderedCollection new.
	SubApplication currentlyLoaded reverseDo: [:app |
		(app respondsTo: #addToDefaultTextMenu:browser:) ifTrue: [
			(app respondsTo: #menuExtensionOrder)
				ifTrue: [
					app menuExtensionOrder isNil
						ifTrue:  [ app addToDefaultTextMenu: aMenu browser: self ]
						ifFalse: [ orderedApps add: app ] ]
				ifFalse: [ app addToDefaultTextMenu: aMenu browser: self ] ]
	].
	(orderedApps asSortedCollection: [:a :b | a menuExtensionOrder < b menuExtensionOrder ])
		do: [:app | app addToDefaultTextMenu: aMenu browser: self ].
	^aMenu
]

{ #category : 'Actions' }
AIRefactoryChangesBrowser >> discard [

	visibleChanges remove: selectedChange.
	changes remove: selectedChange.
	visibleChanges isEmpty ifTrue: [^self close].
	self refresh
]

{ #category : 'Toolbar' }
AIRefactoryChangesBrowser >> editApplication [

	selectedApplication ifNotNil:[ selectedApplication editApplication ]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> highlightAllDifferences [
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
AIRefactoryChangesBrowser >> includeEditMenu [
	^ false
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> includeFileMenu [
	^ false
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> indicatorRange: startChar to: endChar on: editor [
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
AIRefactoryChangesBrowser >> initializeAfterRealize [
	"The widgets are now fully created. Populate them with initial data."

	super initializeAfterRealize.

	"Apply Smalltalk syntax highlighting first"
	leftEditor lexerSmalltalk.
	rightEditor lexerSmalltalk.
	
	"Ensure horizontal scroll width adjusts to the longest visible line"
	leftEditor setScrollWidthTracking: 1.
	rightEditor setScrollWidthTracking: 1.

	self showEmptyEditors
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> initializeComparer [
	"Initialize the comparer with the text from our editors."
	comparer := AIDMPStringComparer new
		string1: leftEditor getString;
		string2: rightEditor getString;
		compare;
		yourself.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> initializeStyles [
	self setupStylesFor: leftEditor.
	self setupStylesFor: rightEditor.
	self setupIndicatorsFor: leftEditor.
	self setupIndicatorsFor: rightEditor.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> initializeVisibleChanges [
	"It's important that the collection object in visibleChanges instvar is not the same collection object as the one in the changes instvar"

	visibleChanges :=
		showOnlyLastChanges ifTrue: [self deduplicateChanges: changes] ifFalse: [changes copy]
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> initializeWithChanges: aCollection [

	changes := OrderedCollection withAll: aCollection.
	showOnlyLastChanges := true.
	self initializeVisibleChanges.
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> markerRange: startChar to: endChar on: editor markerNumber: markerNumber [
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
AIRefactoryChangesBrowser >> merge [

	[selectedChange execute]
		on: Error
		do: [:ex |
			self owningImage message: 'Error applying change: ' , ex description.
			^self].

	self discard
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> newListWidget: listSelector changeSelector: changeSelector printBlock: printBlock statusBlock: statusBlock initialSelection: initialSelection returnItems: returnItemsNotPositions [

	"Private - Answer a new list widget using the arguments."

	| newWidget itemColorBlock itemStatusBlock attributeBlock maxWidth |
	self stsUseEnhancedListWidgets
		ifFalse: [
			^super 
				newListWidget: listSelector
				changeSelector: changeSelector
				printBlock: printBlock
				statusBlock: statusBlock
				initialSelection: initialSelection
				returnItems: returnItemsNotPositions].

	itemColorBlock := self stsItemColorBlockFor: listSelector.
	itemStatusBlock := (self stsStatusBlockFor: listSelector) ifNil: [statusBlock].
	attributeBlock := self stsAttributeBlockFor: listSelector.
	maxWidth := 0.

	newWidget :=
		EwTableList
			createScrolledManagedWidget: listSelector asString
			parent: self defaultWidgetParent
			argBlock: [:w |
				self stsShouldSetListFonts ifTrue: [self setFontListFor: w].
				StsPowerTools enhancedListColor isNil ifFalse: [
					w backgroundColor: StsPowerTools enhancedListColor].
				w
					scrollHorizontal: self listHorizontalScrollBarHint;
					selectionPolicy: XmBROWSESELECT;
					items: (self perform: listSelector);
					selectedItems: (initialSelection isNil ifTrue: [#()] ifFalse: [Array with: initialSelection]);
					itemHeight: nil;
					editable: false;
					headingHeight: self stsHeadingHeight;
					rowSeparators: false;
					separatorsToExtremes: true;
					columns: (OrderedCollection new
						add: (EwTableColumn new
							editable: false;
							verticalSeparatorThickness: 0;
							verticalAlignment: XmALIGNMENTCENTER;
							width: 256;
							addCallback: EwConstants::XmNcellValueCallback
								receiver: [:widget :clientData :callData | | color |
									callData value: (printBlock value: callData item).
									itemStatusBlock isNil
										ifFalse: [| image |
											(image := itemStatusBlock value: callData item) isNil
												ifFalse: [callData value: (WbLabeledImage tightImage: image label: callData value)]].
									attributeBlock isNil
										ifFalse: [| images |
											(images := attributeBlock value: callData item) isEmpty
												ifFalse: [
													images do: [:image |
														callData value: (WbLabeledImage tightImage: callData value label: image)]]].
									maxWidth := maxWidth max: (newWidget rc isNil
										ifTrue: [0] 
										ifFalse: [callData value ewWidthUsing: newWidget rc]) + 4.
									(itemColorBlock notNil and: [(color := itemColorBlock value: callData item) notNil])
										ifTrue: [
											callData 
												foregroundColor: color;
												selectionBackgroundColor: color]]
								selector: #value:value:value:
								clientData: nil;
							yourself);
						yourself)].
	self 
		stsDragDropAdaptersFor: newWidget 
		named: listSelector
		itemStatusBlock: itemStatusBlock.

	newWidget focusProxy
		addEventHandler: KeyPressMask
			receiver: [:widget :clientData :callData |
				self stsHoverHelpWindowHide]
			selector: #value:value:value:
			clientData: nil.

	newWidget basicWidget
		addEventHandler: PointerMotionMask
		receiver: [:widget :clientData :callData | 
			self stsEnhancedListHoverHelp ifTrue: [| item row point selected color value |
				(point := self stsItemPointFor: newWidget visibleAt: callData point) notNil
					ifTrue: [
						((row := newWidget indexAtPoint: callData point) notNil
							and: [(item := newWidget itemAt: row) notNil])
							ifTrue: [
								value := (attributeBlock isNil 
									or: [(value := (attributeBlock value: item) select: [:each | each isString]) isEmpty])
									ifTrue: [String new]
									ifFalse: [' ', value first].								
								selected := newWidget highlightedItemIndexes includes: row.
								self 
									stsHoverHelpWidget: newWidget;
									stsHoverHelpWindowShow: (printBlock value: item), value
										at: (newWidget translateCoords: (point + (itemStatusBlock isNil 
											ifTrue: [0] 
											ifFalse: [((itemStatusBlock value: item) width + 2) @ 0])))
										foreColor: (selected 
											ifTrue: [CwList selectionForegroundColor] 
											ifFalse: [
												(itemColorBlock notNil and: [(color := itemColorBlock value: item) notNil])
													ifTrue: [color]
													ifFalse: [newWidget foregroundColor]])
										backColor: (selected
											ifTrue: [
												(itemColorBlock notNil and: [(color := itemColorBlock value: item) notNil])
													ifTrue: [color]
													ifFalse: [CwList selectionBackgroundColor]] 
											ifFalse: [newWidget backgroundColor])]]
					ifFalse: [self stsHoverHelpWindowHide]]] 
		selector: #value:value:value:
		clientData: nil;

		addCallback: XmNresizeCallback
		receiver: [:widget :clientData :callData |
			(widget propertyAt: #pendingResize) == true ifFalse: [
				widget propertyAt: #pendingResize put: true.
				CwAppContext default asyncExecInUI: [
					newWidget deferRefreshWhile: [
						newWidget columns last width: ((newWidget workWidth max: maxWidth) max: 256).
						widget propertyAt: #pendingResize put: false]]]]
		selector: #value:value:value:
		clientData: nil.
	CwAppContext default asyncExecInUI: [
		newWidget basicWidget isDestroyed ifFalse: [
			newWidget basicWidget callResizeCallback]].

	newWidget
		addCallback: XmNbrowseSelectionCallback
		receiver: self
		selector:
			(returnItemsNotPositions
				ifTrue: [#selectListItem:clientData:callData:]
				ifFalse: [#selectListPosition:clientData:callData:])
		clientData: changeSelector ;

		addCallback: XmNmodifyVerifyCallback
		receiver: self
		selector: #selectionChangeVerify:clientData:callData:
		clientData: nil.

	^newWidget
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> paddingStyle [
	"Return the Scintilla custom style ID used for padding lines"
	^51
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> refresh [

	| uniqueApps |

	uniqueApps := self applications asArray.

	applicationListWidget items: uniqueApps.

	uniqueApps notEmpty
		ifTrue: [
			self restoreSelection: selectedApplication in: applicationListWidget items: uniqueApps]
		ifFalse: [
			classNamesListWidget deleteAllItems.
			changesListWidget deleteAllItems]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> restoreSelection: previousSelection in: listWidget items: items [
	| index |
	items isEmpty ifTrue: [^self].
	index := previousSelection ifNotNil: [items indexOf: previousSelection] ifNil: [0].
	index = 0 ifTrue: [index := 1].
	listWidget selectPos: index notify: true
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> scNotification: aWidget clientData: anObject callData: aCallData [
	"Callback to synchronize scrolling between the two editors."
	| sourceEditor targetEditor firstLine xOffset |
	isScrolling == true ifTrue: [^self]. "Prevent infinite loop"

	aCallData code = SCN_UPDATEUI
		ifTrue:
			[isScrolling := true.
			sourceEditor := aWidget.
			targetEditor := sourceEditor == leftEditor ifTrue: [rightEditor] ifFalse: [leftEditor].

			firstLine := sourceEditor getFirstVisibleLine.
			firstLine ~= targetEditor getFirstVisibleLine ifTrue: [
				targetEditor setFirstVisibleLine: firstLine ].
			
			xOffset := sourceEditor getXOffset.
			xOffset ~= targetEditor getXOffset ifTrue: [
				targetEditor setXOffset: xOffset ].

			isScrolling := false]
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> setupIndicatorsFor: anEditor [
	"Configure indicator 0 (red) for removed characters and 1 (green) for added characters."

	"Configure Indicator 0: Removed (Red)"
	anEditor indicatorSetStyle: 0 style: INDIC_STRAIGHTBOX. 
	anEditor indicatorSetFore: 0 color: 16r0000FF. "BBGGRR"
	anEditor indicatorSetAlpha: 0 alpha: 60. 
	anEditor indicatorSetOutlineAlpha: 0 alpha: 100. 
	anEditor indicatorSetUnder: 0 under: 1.

	"Configure Indicator 1: Added (Green)"
	anEditor indicatorSetStyle: 1 style: INDIC_STRAIGHTBOX. 
	anEditor indicatorSetFore: 1 color: 16r00AA00. "BBGGRR - slightly darker green"
	anEditor indicatorSetAlpha: 1 alpha: 60. 
	anEditor indicatorSetOutlineAlpha: 1 alpha: 100. 
	anEditor indicatorSetUnder: 1 under: 1.
]

{ #category : 'Initialization',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> setupStylesFor: anEditor [
	"Configure styles for diff lines and light grey padding backgrounds."

	"Marker 1 (Light Red) for Left Editor (Removed)"
	anEditor markerDefine: 1 markerSymbol: SC_MARK_BACKGROUND. 
	anEditor markerSetBack: 1 colour: 16rEAEAFE. "BBGGRR format"

	"Marker 2 (Light Green) for Right Editor (Added)"
	anEditor markerDefine: 2 markerSymbol: SC_MARK_BACKGROUND. 
	anEditor markerSetBack: 2 colour: 16rDDF0E6. "BBGGRR format"
		
	"Style for Padding lines (Very Light Grey)"
	anEditor 
		styleSetBack: self paddingStyle color: 16rF5F5F5; "BBGGRR format"
		styleSetEolFilled: self paddingStyle value: true.
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> showEmptyEditors [

	self updateDiffViewLeft: '' right: ''.
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> showOnlyLastChangesChanged: widget clientData: clientData callData: callData [

	showOnlyLastChanges := callData set.
	self initializeVisibleChanges.
	self refresh
]

{ #category : 'Toolbar',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> stsDefaultToolBar [

	^OrderedCollection new
		addAll: #(
			#menuFileNew
			#menuFileOpen
			#space
			#menuFileSaveImage
			#space
			#menuEditCopy
			#space
			"#menuEditUndo"
			#space
			#menuEditFindReplace
			#space
			#menuEditExecute
			#menuEditDisplay
			#menuEditInspect
			#stsMenuEditDebug
			#space
			#stsSenders
			#stsImplementors
			#space
			#classReferences
			#browseHierarchy
			#browseClass
			#space
			#editApplication
			#stsOpenApplicationManager
			#stsConfigureApplication
			#stsOpenConfigMapsBrowser
			#space
			#menuFileSetBrowserFont
			#stsSetBrowserColors
		);
		yourself
]

{ #category : 'Internal' }
AIRefactoryChangesBrowser >> stsItemColorBlockFor: widgetName [
	widgetName == #applications ifTrue: [
		^[:app | (StsApplicationManager stsCacheEntriesFor: app) value]
	].
	
	widgetName == #classNames
		ifTrue: [
			^[:clName | | colorUnreleasedClasses cl |
				cl := Smalltalk at: (self baseClassNameFor: clName) asSymbol ifAbsent: [nil].
				(StsPowerTools useItemColors
					and: [(colorUnreleasedClasses := StsPowerTools colorUnreleasedClasses) notNil])
					ifTrue: [
						cl isNil 
							ifTrue: [
								selectedApplication isScratch
									ifTrue: [StsPowerTools colorScratchClasses]
									ifFalse: [colorUnreleasedClasses]
							]
							ifFalse: [
								(EtTools managerInterface isClassReleased: cl in: selectedApplication)
									ifTrue: [nil]
									ifFalse: [
										selectedApplication isScratch
											ifTrue: [StsPowerTools colorScratchClasses]
											ifFalse: [
												(cl isEditionIn: selectedApplication)
													ifTrue: [colorUnreleasedClasses]
													ifFalse: [StsPowerTools colorUnreleasedClassVersions]]]]]
					ifFalse: [nil]]].
					
	widgetName == #changesForClass
		ifTrue: [
			^[:change |
				((change isKindOf: RemoveClassChange) or: [change isKindOf: RemoveMethodChange])
					ifTrue: [Color red]
					ifFalse: [Color darkGreen]]].
					
	^super stsItemColorBlockFor: widgetName
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> stsStatusBlockFor: widgetName [
	widgetName == #applications
		ifTrue: [
			^[:app | (StsApplicationManager stsCacheEntriesFor: app) key]].

	widgetName == #classNames
		ifTrue: [
			^[:clName | | cl |
				cl := Smalltalk at: (self baseClassNameFor: clName) asSymbol ifAbsent: [nil].
				cl isNil 
					ifTrue: [
						selectedApplication isScratch
							ifTrue: [self stsImageNamed: StsPowerTools iconScratchClasses]
							ifFalse: [self stsImageNamed: StsPowerTools iconUnreleasedDefinedClasses]
					]
					ifFalse: [
						((EtTools managerInterface isClassReleased: cl in: selectedApplication) 
							or: [(self stsSuperUser or: [(selectedApplication ownerOf: cl) == EmUser current]) not])
							ifTrue: [
								cl == selectedApplication
									ifTrue: [self stsImageNamed: StsPowerTools iconMarkedApplications]
									ifFalse: [
										cl controller == selectedApplication
											ifTrue: [self stsImageNamed: StsPowerTools iconDefinedClasses]
											ifFalse: [self stsImageNamed: StsPowerTools iconExtendedClasses]]]
							ifFalse: [
								selectedApplication isScratch
									ifTrue: [
										cl == selectedApplication
											ifTrue: [self stsImageNamed: StsPowerTools iconScratchApplications]
											ifFalse: [self stsImageNamed: StsPowerTools iconScratchClasses]]
									ifFalse: [
										cl == selectedApplication
											ifTrue: [self stsImageNamed: StsPowerTools iconMarkedModifiedApplications]
											ifFalse: [
												cl controller == selectedApplication
													ifTrue: [self stsImageNamed: StsPowerTools iconUnreleasedDefinedClasses]
													ifFalse: [self stsImageNamed: StsPowerTools iconUnreleasedExtendedClasses]]]]]]].

	^super stsStatusBlockFor: widgetName
]

{ #category : 'Toolbar',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> stsSupportsToolBars [

	^StsPowerTools canUseToolBars
]

{ #category : 'StS Power Tools' }
AIRefactoryChangesBrowser >> stsUpdateStyling [

	StsPowerTools stsTextWidgetsSupportColor ifFalse: [^self].
	(Array with: leftEditor with: rightEditor) do: [:aTextWidget |
		(aTextWidget isNil or: [aTextWidget isDestroyed])
			ifFalse: [
				aTextWidget stsUpdateStylingFor: self.
				aTextWidget isDestroyed ifFalse: [aTextWidget redraw]]].
	self initializeStyles
]

{ #category : 'Accessing' }
AIRefactoryChangesBrowser >> textMenu2 [
	"Answer the popup menu for the second text widget."

	textMenu2 notNil ifTrue: [^textMenu2].
	^textMenu2 := self defaultTextMenu
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> updateDiffViewLeft: leftString1 right: rightString1 [
	| lString rString |

	"Clear previous styling so the lexer can take over correctly"
	leftEditor clearDocumentStyle.
	rightEditor clearDocumentStyle.
	
	"Reset scroll width to 1 so tracking can scale it to the exact text width"
	leftEditor setScrollWidth: 1.
	rightEditor setScrollWidth: 1.

	lString := leftString1 ifNil: [''] ifNotNil: [leftString1 asString].
	rString := rightString1 ifNil: [''] ifNotNil: [rightString1 asString].

	lString := lString copyReplaceAll: String crlf with: String cr.
	lString := lString copyReplaceAll: String lf with: String cr.
	
	rString := rString copyReplaceAll: String crlf with: String cr.
	rString := rString copyReplaceAll: String lf with: String cr.

	"Set strings"
	leftEditor setReadonly: false; setText: lString.
	rightEditor setReadonly: false; setText: rString.

	"Do the comparison and apply marker styling"
	self initializeComparer.
	self initializeStyles.
	self highlightAllDifferences.
	self alignEditors.
	
	"Make editors read-only"
	leftEditor setReadonly: true.
	rightEditor setReadonly: true
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIRefactoryChangesBrowser >> widgetForTextMenu [

	"Private - Answer the text widget which receives the generic edit
	 menu commands or nil if there is no such widget.  This is the
	 default text widget."
	
	^ leftEditor
]
