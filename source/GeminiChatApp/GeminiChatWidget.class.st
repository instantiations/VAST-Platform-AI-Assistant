Class {
	#name : 'GeminiChatWidget',
	#superclass : 'CwExtendedPrimitive',
	#instVars : [
		'chat',
		'scrollBar',
		'scrollBarValueFactor',
		'drawingArea',
		'drawnInteractableAreas',
		'pointedToInteractableArea',
		'selecting',
		'selectionScrollTimeoutID',
		'selectionStartPoint',
		'selectionEndPoint',
		'selectedString',
		'scrollBarNextMinMaxValue',
		'scrollBarMinMaxValue'
	],
	#classVars : [
		'BaseFontSize',
		'HeadingFontSets',
		'BaseFontSet'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatWidget class >> baseFontSet [

	^ BaseFontSet ifNil: [ BaseFontSet := GeminiFontSet size: self baseFontSize ]
]

{ #category : 'Not categorized' }
GeminiChatWidget class >> baseFontSize [

	^ BaseFontSize ifNil: [ 100 ]
]

{ #category : 'Not categorized' }
GeminiChatWidget class >> baseFontSize: newSize [

	CwAppContext default asyncExecInUI: [
		BaseFontSize := newSize.
		self resetFontSets.
		self allInstances do: [ :widget |
			widget isRealized ifTrue: [
				widget resetTextSegmentLayout ] ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget class >> headingFontSets [

	^ HeadingFontSets ifNil: [ HeadingFontSets := #(150 125 110 100) collect: [ :factor | GeminiFontSet size: self baseFontSize * factor // 100 ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget class >> resetFontSets [

	BaseFontSet ifNotNil: [
		BaseFontSet freeFonts.
		BaseFontSet := nil ].
	HeadingFontSets ifNotNil: [
		HeadingFontSets do: [ :headingFontSet | headingFontSet freeFonts ].
		HeadingFontSets := nil ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> addSelectionScrollTimeout [

	selectionScrollTimeoutID := CwAppContext default addTimeout: 25 receiver: self selector: #selectionScrollTimeoutElapsed: clientData: nil
]

{ #category : 'Not categorized' }
GeminiChatWidget >> chat [

	^ chat
]

{ #category : 'Not categorized' }
GeminiChatWidget >> chat: newChat [

	chat ifNotNil: [ Error signal: 'Chat already set' ].
	chat := newChat.
	chat addDependent: self.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> codeElementReferencingClassNameColor [

	^ self linkColor
]

{ #category : 'Not categorized' }
GeminiChatWidget >> createPrimaryWidget: name parent: parent argBlock: argBlock [

	^ parent createScrolledWindow: name , 'ScrolledWindow' argBlock: [ :w | w clipBackgroundColor: Color white. argBlock value: w ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> createWidgetSystem [

	(scrollBar := self primaryWidget createScrollBar: self primaryWidget name , 'ScrollBar' argBlock: nil)
		manageChild;
		valueChangedCallback: (OrderedCollection with: (CwCallbackRec
			receiver: self
			selector: #scrollBarValueChanged:clientData:callData:
			clientData: nil));
		dragCallback: (OrderedCollection with: (CwCallbackRec
			receiver: self
			selector: #scrollBarValueChanged:clientData:callData:
			clientData: nil)).
	(drawingArea := GeminiDrawingArea createWidget: self primaryWidget name , 'DrawingArea' parent: self primaryWidget argBlock: nil)
		manageChild;
		addCallback: XmNexposeCallback
			receiver: self
			selector: #drawingAreaExposed:clientData:callData:
			clientData: nil;
		addEventHandler: ButtonPressMask
			receiver: self
			selector: #drawingAreaButtonPress:clientData:callData:
			clientData: nil;
		addEventHandler: PointerMotionMask
			receiver: self
			selector: #drawingAreaPointerMotion:clientData:callData:
			clientData: nil;
		addEventHandler: ButtonReleaseMask
			receiver: self
			selector: #drawingAreaButtonRelease:clientData:callData:
			clientData: nil.
	self primaryWidget setAreas: nil verticalScrollbar: scrollBar workRegion: drawingArea.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawBottomBackground: dc [

	dc pixmap fillRectangle: dc gc x: dc baseLeftInset y: dc y + dc yOffset
		width: (drawingArea width - dc rightInset - dc baseLeftInset)
		height: dc padding.
	dc gc setArcMode: ArcPieSlice.
	dc pixmap fillArc: dc gc x: dc baseLeftInset - dc padding y: dc y + dc yOffset - dc padding width: dc padding * 2 height: dc padding * 2 angle1: 64 * 180 angle2: 64 * 90.
	dc pixmap fillArc: dc gc x: (drawingArea width - dc rightInset - dc padding) y: dc y + dc yOffset - dc padding width: dc padding * 2 height: dc padding * 2 angle1: 64 * 270 angle2: 64 * 90.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawLeafTextBlock: textBlock dc: dc [

	dc fontSet: (textBlock isHeadingBlock ifTrue: [ self class headingFontSets at: (textBlock level min: self class headingFontSets size) ] ifFalse: [ self class baseFontSet ]).
	dc ascent: dc fontSet proportional normal ascent.
	dc descent: dc fontSet proportional normal descent.
	dc withTextMonospaced: false do: [
		dc withTextBolded: textBlock isHeadingBlock do: [
			dc withTextItalicized: false do: [
				| startY |
				self updateSelectionStartEndX: dc.
				startY := dc y.
				dc withLeftInsetIncreasedBy: (textBlock isCodeBlock ifTrue: [ dc leftInsetCodeBlockIncrement ] ifFalse: [ 0 ]) do: [
					dc x: dc leftInset.
					self drawTextElementOfTextBlock: textBlock dc: dc ].
				textBlock isCodeBlock ifTrue: [
					self drawMarkerTextBlockCode: textBlock startY: startY dc: dc ] ] ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawMarkerTextBlockCode: textBlock startY: startY dc: dc [

	| markerRectangle |

	dc gc setForeground: (dc pixmap getPalette nearestPixelValue: (textBlock isPointedTo ifTrue: [ self pointedToCodeTextBlockColor ] ifFalse: [ Color lightGray ])).
	markerRectangle := Rectangle origin: (dc leftInset + (dc leftInsetCodeBlockIncrement // 4)) @ startY
		extent: 3 @ (dc y - startY).
	dc pixmap fillRectangles: dc gc rectangles: { markerRectangle translateBy: 0 @ dc yOffset }.
	dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangle: (markerRectangle expandBy: 5 @ 2) handler: textBlock).
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawMiddleBackground: dc [

	dc backgroundColor ifNil: [ ^ self ].
	dc gc setForeground: (dc pixmap getPalette nearestPixelValue: dc backgroundColor).
	dc pixmap fillRectangle: dc gc x: dc baseLeftInset - dc padding y: dc y + dc yOffset
		width: ((drawingArea width - dc rightInset + dc padding) - (dc baseLeftInset - dc padding))
		height: dc ascent + dc descent
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawPendingListMarkers: dc [

	[ dc pendingListMarkers notEmpty ] whileTrue: [
		| leftInset listItemBlock markerString |
		leftInset := dc pendingListMarkers last key.
		listItemBlock := dc pendingListMarkers removeLast value.
		markerString := listItemBlock markerString , (String new: 3 withAll: Character space).
		dc gc setFont: self class baseFontSet proportional normal font.
		dc gc setForeground: (dc pixmap getPalette nearestPixelValue: dc textColor).
		dc pixmap drawString: dc gc x: leftInset - (self class baseFontSet proportional normal textWidth: markerString) y: dc y + dc ascent + dc yOffset string: markerString ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawStringLayout: layout dc: dc [

	| drawnAreas |

	dc gc setFont: dc fontStruct font.
	drawnAreas := OrderedCollection new.
	layout
		do: [ :line |
			line
				do: [ :tabPart |
					tabPart
						do: [ :drawnString |
							| textWidth |
							(selectionEndPoint notNil and: [ dc selectionStartX < Float infinity and: [ dc selectionEndX > dc x ] ]) ifTrue: [
								| selectionStartIndex selectionEndIndex |
								selectionStartIndex := (1 to: drawnString size) findFirst: [ :index |
									(dc x + (dc fontStruct textWidth: (drawnString copyFrom: 1 to: index))) > dc selectionStartX ].
								selectionStartIndex ~= 0 ifTrue: [
									selectionEndIndex := (1 to: drawnString size) findLast: [ :index |
										(dc x + (dc fontStruct textWidth: (drawnString copyFrom: 1 to: index - 1))) < dc selectionEndX ].
										selectionEndIndex ~= 0 ifTrue: [
											dc selectionStream nextPutAll: (drawnString copyFrom: selectionStartIndex to: selectionEndIndex).
											dc gc setForeground: (dc pixmap getPalette nearestPixelValue: Color selectionBackground).
											dc pixmap fillRectangle: dc gc x: dc x + (dc fontStruct textWidth: (drawnString copyFrom: 1 to: selectionStartIndex - 1))
												y: dc y + dc yOffset width: (dc fontStruct textWidth: (drawnString copyFrom: selectionStartIndex to: selectionEndIndex)) height: dc ascent + dc descent ] ] ].
							dc gc setForeground: (dc pixmap getPalette nearestPixelValue: dc textColor).
							dc pixmap drawString: dc gc x: dc x y: dc y + dc ascent + dc yOffset string: drawnString.
							textWidth := dc fontStruct textWidth: drawnString.
							drawnAreas add: (Rectangle origin: dc x @ dc y extent: textWidth @ (dc ascent + dc descent)).
							dc x: dc x + textWidth ]
						separatedBy: [
							dc x: dc leftInset.
							dc y: dc y + dc ascent + dc descent.
							dc ascent: dc fontSet proportional normal ascent.
							dc descent: dc fontSet proportional normal descent.
							self drawMiddleBackground: dc.
							self updateSelectionStartEndX: dc ] ]
				separatedBy: [
					| newX |
					newX := dc x - dc leftInset // dc tabWidth + 1 * dc tabWidth + dc leftInset.
					selectionEndPoint ifNotNil: [
						(dc x < dc selectionEndX and: [ newX > dc selectionStartX ]) ifTrue: [
							dc selectionStream tab.
							dc gc setForeground: (dc pixmap getPalette nearestPixelValue: Color selectionBackground).
							dc pixmap fillRectangle: dc gc x: dc x y: dc y + dc yOffset width: newX - dc x height: dc ascent + dc descent ] ].
					drawnAreas add: (Rectangle origin: dc x @ dc y extent: (newX - dc x) @ (dc ascent + dc descent)).
					dc x: newX.
					dc x > (drawingArea width - dc rightInset) ifTrue: [
						dc x: dc leftInset.
						dc y: dc y + dc ascent + dc descent.
						dc ascent: dc fontSet proportional normal ascent.
						dc descent: dc fontSet proportional normal descent.
						self drawMiddleBackground: dc.
						self updateSelectionStartEndX: dc ] ] ]
		separatedBy: [
			selectionEndPoint ifNotNil: [
				(dc x >= dc selectionStartX and: [ dc x < dc selectionEndX ]) ifTrue: [
					dc selectionStream newLine ] ].
			dc x: dc leftInset.
			dc y: dc y + dc ascent + dc descent.
			dc ascent: dc fontSet proportional normal ascent.
			dc descent: dc fontSet proportional normal descent.
			self drawMiddleBackground: dc.
			self updateSelectionStartEndX: dc ].
	^ drawnAreas
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlock: textBlock dc: dc [

	textBlock drawOnChatWidget: self dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockCode: textBlock dc: dc [

	self drawLeafTextBlock: textBlock dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockFunctionCalls: textBlock dc: dc [

	| startY |

	dc y: dc y + self class baseFontSet proportional normal ascent + self class baseFontSet proportional normal descent.
	startY := dc y.
	dc withTextColor: (textBlock isPointedTo ifTrue: [ Color gray ] ifFalse: [ Color darkGray ]) do: [
		self drawTextBlock: (GeminiTextBlockText text: (GeminiTextElementString string: 'Function calls: ' , (self toggleIndicatorExpanded: textBlock isExpanded))) dc: dc ].
	dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangle: (Rectangle origin: dc leftInset @ startY corner: dc x @ dc y) handler: textBlock).
	textBlock isExpanded ifTrue: [
		| sequenceBlock |
		sequenceBlock := GeminiTextBlockSequence new.
		textBlock functionCalls do: [ :functionCall |
			sequenceBlock addBlock: ((GeminiTextBlockListItem marker: '*' indentationLevel: 2)
				addBlock: (GeminiTextBlockText text: (GeminiTextElementString string: functionCall displayString));
				yourself) ].
		dc withTextColor: Color darkGray do: [
			self drawTextBlock: sequenceBlock dc: dc ] ].
	dc y: dc y + self class baseFontSet proportional normal ascent + self class baseFontSet proportional normal descent.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockHeading: textBlock dc: dc [

	self drawLeafTextBlock: textBlock dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockListItem: textBlock dc: dc [

	self drawTextBlockListItemOrNumberedListItem: textBlock dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockListItemOrNumberedListItem: textBlock dc: dc [

	dc withLeftInsetIncreasedBy: dc leftInsetListItemBlockIncrement do: [
		dc pendingListMarkers add: dc leftInset -> textBlock.
		self drawTextBlock: textBlock sequenceBlock dc: dc ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockNumberedListItem: textBlock dc: dc [

	self drawTextBlockListItemOrNumberedListItem: textBlock dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockQuote: textBlock dc: dc [

	| outerStartY markerRectangle |

	outerStartY := dc y.
	dc withLeftInsetIncreasedBy: dc leftInsetQuoteBlockIncrement do: [
		self drawTextBlock: textBlock sequenceBlock dc: dc ].
	dc gc setForeground: (dc pixmap getPalette nearestPixelValue: Color lightGray).
	markerRectangle := Rectangle origin: (dc leftInset + (dc leftInsetQuoteBlockIncrement // 4)) @ outerStartY extent: 1 @ (dc y - outerStartY).
	dc pixmap fillRectangles: dc gc rectangles: { markerRectangle translateBy: 0 @ dc yOffset }.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockSequence: textBlock dc: dc [

	textBlock blocks do: [ :containedTextBlock |
		self drawTextBlock: containedTextBlock dc: dc ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockText: textBlock dc: dc [

	^ self drawLeafTextBlock: textBlock dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockThought: textBlock dc: dc [

	| topicSuffix startY |

	topicSuffix := ((textBlock isExpanded not and: [ dc textSegment textBlocks size = 1 ]) ifTrue: [ textBlock lastTopicLine ])
		ifNil: [ '' ]
		ifNotNil: [ :lastTopicLine | ' ' , lastTopicLine ].
	startY := dc y.
	dc withTextColor: Color darkGray do: [
		dc withTextColor: (textBlock isPointedTo ifTrue: [ Color gray ] ifFalse: [ dc textColor ]) do: [
			self drawTextBlock: (GeminiTextBlockText text: (GeminiTextElementString string: 'Thoughts ' , (self toggleIndicatorExpanded: textBlock isExpanded) , topicSuffix)) dc: dc ].
		dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangle: (Rectangle origin: dc leftInset @ startY corner: dc x @ dc y) handler: textBlock).
		textBlock isExpanded ifTrue: [
			self drawTextBlock: textBlock sequenceBlock dc: dc
		] ifFalse: [
			dc y: dc y + self class baseFontSet proportional normal ascent + self class baseFontSet proportional normal descent ] ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlocksOfTextSegment: textSegment dc: dc [

	textSegment textBlocks do: [ :textBlock |
		self drawTextBlock: textBlock dc: dc ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElement: textElement dc: dc [

	^ textElement drawOnChatWidget: self dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementAction: textElement dc: dc [

	| textColor |

	textColor := textElement isPointedTo ifTrue: [ self pointedToLinkColor ] ifFalse: [ self linkColor ].
	^ dc withTextColor: textColor do: [
			| drawnAreas |
			drawnAreas :=self drawTextElement: textElement element dc: dc.
			dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangles: drawnAreas handler: textElement).
			drawnAreas ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementCode: textElement dc: dc [

	^ dc withTextMonospaced: true do: [
		| hasBrowsableReference textColor |
		hasBrowsableReference := dc textElementLink isNil and: [ textElement referencesClass or: [ textElement referencesMethod ] ].
		textColor := hasBrowsableReference
			ifTrue: [ textElement isPointedTo ifTrue: [ self pointedToCodeElementReferencingClassNameColor ] ifFalse: [ self codeElementReferencingClassNameColor ] ]
			ifFalse: [ dc textColor ].
		dc withTextColor: textColor do: [
			| drawnAreas |
			drawnAreas := self drawTextString: textElement codeTextString dc: dc.
			hasBrowsableReference ifTrue: [
				dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangles: drawnAreas handler: textElement) ].
			drawnAreas ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementEmphasis: textElement dc: dc [

	^ textElement isStrong
		ifTrue: [
			dc withTextBolded: true do: [
				self drawTextElement: textElement element dc: dc ] ]
		ifFalse: [
			dc withTextItalicized: true do: [
				self drawTextElement: textElement element dc: dc ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementLink: textElement dc: dc [

	| textColor |

	textColor := textElement hasBrowsableDestination ifTrue: [ textElement isPointedTo ifTrue: [ self pointedToLinkColor ] ifFalse: [ self linkColor ] ] ifFalse: [ dc textColor ].
	^ dc withTextColor: textColor do: [
		dc withTextElementLink: textElement do: [
			| drawnAreas |
			drawnAreas := self drawTextElement: textElement element dc: dc.
			textElement hasBrowsableDestination ifTrue: [
				dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangles: drawnAreas handler: textElement) ].
			drawnAreas ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementOfTextBlock: textBlock dc: dc [

	| textElement |

	textElement := textBlock textElement.
	self drawMiddleBackground: dc.
	self drawPendingListMarkers: dc.
	self drawTextElement: textElement dc: dc.
	selectionEndPoint ifNotNil: [
		(dc x >= dc selectionStartX and: [ dc x < dc selectionEndX ]) ifTrue: [
			dc selectionStream newLine ] ].
	dc y: dc y + dc ascent + dc descent.
	self updateSelectionStartEndX: dc.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementSequence: textElement dc: dc [

	| drawnAreas |

	drawnAreas := OrderedCollection new.
	textElement elements do: [ :containedTextElement |
		drawnAreas addAll: (self drawTextElement: containedTextElement dc: dc) ].
	^ drawnAreas
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementString: textElement dc: dc [

	^ self drawTextString: textElement textString dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextSegment: textSegment dc: dc [

	| startY |
	
	startY := dc y.
	dc
		textSegment: textSegment;
		textColor: textSegment textColor;
		backgroundColor: nil;
		padding: nil.
	textSegment drawOnChatWidget: self dc: dc.
	^ dc y - startY 
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextSegmentDelay: textSegment dc: dc [

	self drawTextBlocksOfTextSegment: textSegment dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextSegmentError: textSegment dc: dc [

	self drawTextBlocksOfTextSegment: textSegment dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextSegmentModelMessage: textSegment dc: dc [

	self drawTextBlocksOfTextSegment: textSegment dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextSegmentSystemInstruction: textSegment dc: dc [

	| startY |

	startY := dc y.
	dc withTextColor: (textSegment isPointedTo ifTrue: [ Color gray ] ifFalse: [ dc textColor ]) do: [
		self drawTextBlock: (GeminiTextBlockText text: (GeminiTextElementString string: 'System Instruction ' , (self toggleIndicatorExpanded: textSegment isExpanded))) dc: dc ].
	dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangle: (Rectangle origin: dc leftInset @ startY corner: dc x @ dc y) handler: textSegment).
	textSegment isExpanded ifTrue: [
		self drawTextBlocksOfTextSegment: textSegment dc: dc ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextSegmentUserMessage: textSegment dc: dc [

	dc
		backgroundColor: self userMessageBackgroundColor;
		padding: 10.
	self drawTopBackground: dc.
	dc y: dc y + dc padding.
	self drawTextBlocksOfTextSegment: textSegment dc: dc.
	dc gc setForeground: (dc pixmap getPalette nearestPixelValue: dc backgroundColor).
	self drawBottomBackground: dc.
	dc y: dc y + dc padding.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextSegments: dc [

	chat textSegments
		do: [ :textSegment |
			| textSegmentHeight |
			textSegmentHeight := textSegment height.
			(textSegmentHeight isNil or: [ 
				((dc y + textSegmentHeight) > (scrollBar value * scrollBarValueFactor) and: [ dc y < (scrollBar value * scrollBarValueFactor + drawingArea height) ]) or: [
					selectionEndPoint notNil and: [ (dc y + textSegmentHeight) > (selectionStartPoint y min: selectionEndPoint y) and: [ dc y < (selectionStartPoint y max: selectionEndPoint y) ] ] ] ])
						ifFalse: [
							dc y: dc y + textSegmentHeight
						] ifTrue: [
							textSegment height: (self drawTextSegment: textSegment dc: dc) ] ]
		separatedBy: [
			dc y: dc y + (self class baseFontSet proportional normal height * 3 // 2) ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextString: textString dc: dc [

	| fontStyles |

	fontStyles := dc textMonospaced ifTrue: [ dc fontSet monospaced ] ifFalse: [ dc fontSet proportional ].
	dc fontStruct: (dc textBolded
		ifTrue: [ dc textItalicized ifTrue: [ fontStyles boldItalic ] ifFalse: [ fontStyles bold ] ]
		ifFalse: [ dc textItalicized ifTrue: [ fontStyles italic ] ifFalse: [ fontStyles normal ] ]).
	textString layout ifNil: [
		textString layout: (self layOutString: textString string dc: dc) ].
	^ self drawStringLayout: textString layout dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTopBackground: dc [

	dc gc setForeground: (dc pixmap getPalette nearestPixelValue: dc backgroundColor).
	dc pixmap fillRectangle: dc gc x: dc baseLeftInset y: dc y + dc yOffset
		width: (drawingArea width - dc rightInset - dc baseLeftInset)
		height: dc padding.
	dc gc setArcMode: ArcPieSlice.
	dc pixmap fillArc: dc gc x: dc baseLeftInset - dc padding y: dc y + dc yOffset width: dc padding * 2 height: dc padding * 2 angle1: 64 * 90 angle2: 64 * 90.
	dc pixmap fillArc: dc gc x: (drawingArea width - dc rightInset - dc padding) y: dc y + dc yOffset width: dc padding * 2 height: dc padding * 2 angle1: 64 * 0 angle2: 64 * 90.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawingAreaButtonPress: ignored clientData: clientData callData: buttonEvent [

	| point |

	buttonEvent button = Button1 ifFalse: [ ^ self ].
	point := buttonEvent point + (0 @( scrollBar value * scrollBarValueFactor)).
	(drawnInteractableAreas detect: [ :interactableArea | interactableArea containsPoint: point ] ifNone: [ nil ])
		ifNotNil: [ :interactableArea |
			interactableArea buttonPressedIn: self ]
		ifNil: [
			(buttonEvent state anyMask: ShiftMask) ifTrue: [
				selectionStartPoint ifNotNil: [
					selectionEndPoint := point.
					CwAppContext default asyncExecInUI: [
						drawingArea redraw ] ]
			] ifFalse: [
				selecting := true.
				selectionStartPoint := point.
				selectionEndPoint := nil.
				CwAppContext default asyncExecInUI: [
					drawingArea redraw ] ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawingAreaButtonRelease: ignored clientData: clientData callData: buttonEvent [

	buttonEvent button = Button1 ifFalse: [ ^ self ].
	selecting := false.
	self removeSelectionScrollTimeout.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawingAreaExposed: ignored clientData: clientData callData: callData [

	| dc spacing |

	(dc := GeminiChatWidgetDrawingContext new)
		pixmap: (drawingArea window createDpiPixmap: (DPIScaler autoScaleUp: drawingArea width drawable: drawingArea window)
			height: (DPIScaler autoScaleUp: callData event height drawable: drawingArea window) depth: drawingArea window depth);
		gc: (dc pixmap createGC: CgConstants::None values: nil);
		tabWidth: (self class baseFontSet proportional normal textWidth: (String new: 4 withAll: Character space));
		baseLeftInset: 20;
		leftInset: dc baseLeftInset;
		leftInsetCodeBlockIncrement: dc tabWidth;
		leftInsetQuoteBlockIncrement: dc tabWidth;
		leftInsetListItemBlockIncrement: (self class baseFontSet proportional normal textWidth: (String new: 8 withAll: Character space));
		rightInset: 20;
		yOffset: (scrollBar value * scrollBarValueFactor) negated;
		y: self class baseFontSet proportional normal height * 3 // 2;
		pendingListMarkers: OrderedCollection new;
		interactableAreas: OrderedCollection new;
		selectionStream: ((WriteStream on: String new) lineDelimiter: String crlf; yourself).
	dc pixmap setPalette: (CgIndexedPalette colors: CgIndexedPalette default colors , { Color selectionBackground.
		self userMessageBackgroundColor. self pointedToCodeTextBlockColor.
		self codeElementReferencingClassNameColor. self pointedToCodeElementReferencingClassNameColor.
		Color lightGray }).
	dc gc setForeground: (dc pixmap getPalette nearestPixelValue: Color white).
	dc pixmap fillRectangle: dc gc x: 0 y: 0 width: dc pixmap width height: dc pixmap height.
	self drawTextSegments: dc.
	chat isActivelyGenerating ifTrue: [
		dc gc setFont: self class baseFontSet proportional normal font; setForeground: (dc pixmap getPalette nearestPixelValue: Color darkGray).
		dc pixmap drawString: dc gc x: dc leftInset y: dc y + self class baseFontSet proportional normal ascent + dc yOffset string: '...'.
		dc y: dc y + self class baseFontSet proportional normal height ].
	dc pixmap copyArea: drawingArea window gc: dc gc srcX: callData event x srcY: 0
		srcWidth: drawingArea width srcHeight: callData event height
		destX: callData event x destY: callData event y destWidth: drawingArea width destHeight: callData event height.
	spacing := self class baseFontSet proportional normal height * 3 // 4.
	scrollBarNextMinMaxValue := dc y + spacing.
	scrollBar
		maximum: (scrollBarNextMinMaxValue + spacing max: (scrollBarMinMaxValue + drawingArea height)) + scrollBarValueFactor - 1 // scrollBarValueFactor;
		sliderSize: drawingArea height + scrollBarValueFactor - 1 // scrollBarValueFactor;
		increment: self class baseFontSet proportional normal height + scrollBarValueFactor - 1 // scrollBarValueFactor;
		pageIncrement: drawingArea height + scrollBarValueFactor - 1 // scrollBarValueFactor.
	drawnInteractableAreas := dc interactableAreas.
	selectedString := dc selectionStream contents.
	dc gc freeGC.
	dc pixmap freePixmap.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawingAreaPointerMotion: ignored clientData: clientData callData: motionEvent [

	| point |

	point := motionEvent point + (0 @ (scrollBar value * scrollBarValueFactor)).
	selecting ifTrue: [
		selectionEndPoint := point.
		selectionScrollTimeoutID ifNil: [
			(motionEvent point y between: 0 and: drawingArea height) ifFalse: [
				self addSelectionScrollTimeout ] ].
		CwAppContext default asyncExecInUI: [
			drawingArea redraw ]
	] ifFalse: [
		pointedToInteractableArea ifNotNil: [
			(pointedToInteractableArea containsPoint: point) ifTrue: [
				^ self
			] ifFalse: [
				pointedToInteractableArea pointerLeftIn: self.
				pointedToInteractableArea := nil ] ].
		(pointedToInteractableArea := drawnInteractableAreas detect: [ :interactableArea | interactableArea containsPoint: point ] ifNone: [ ^ self ])
			pointerEnteredIn: self ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> initialize [

	super initialize.
	scrollBarValueFactor := self class baseFontSet proportional normal height.
	selecting := false.
	selectionScrollTimeoutID := nil.
	scrollBarMinMaxValue := 0.
	scrollBarNextMinMaxValue := 0.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> initializeAfterCreate [

	super initializeAfterCreate.
	self primaryWidget
		addCallback: XmNexposeCallback
			receiver: self
			selector: #scrolledWindowExposedOrResized:clientData:callData:
			clientData: nil;
		addCallback: XmNresizeCallback
			receiver: self
			selector: #scrolledWindowExposedOrResized:clientData:callData:
			clientData: nil;
		addCallback: XmNdestroyCallback
			receiver: self
			selector: #scrolledWindowDestroyed:clientData:callData:
			clientData: nil
]

{ #category : 'Not categorized' }
GeminiChatWidget >> layOutString: textString dc: dc [

	^ Array streamContents: [ :lineStream |
		| x |
		x := dc x.
		(textString class crlf split: textString)
			do: [ :lineString |
				lineStream nextPut: (Array streamContents: [ :tabPartStream |
					(Character tab split: lineString)
						do: [ :string |
							tabPartStream nextPut: (Array streamContents: [ :drawnStringStream |
								| startIndex |
								startIndex := 1.
								[ startIndex <= string size ] whileTrue: [
									| maxWidth leftIndex rightIndex distance drawnString textWidth |
									maxWidth := drawingArea width - dc rightInset - x.
									leftIndex := startIndex.
									rightIndex := string size + 1.
									[ (distance := rightIndex - leftIndex) > 1 ] whileTrue: [
										| width middleIndex |
										middleIndex := leftIndex + (distance // 2).
										width := dc fontStruct textWidth: (string copyFrom: startIndex to: middleIndex).
										width <= maxWidth ifTrue: [
											leftIndex := middleIndex.
										] ifFalse: [
											rightIndex := middleIndex ] ].
									leftIndex < string size ifTrue: [
										(string at: leftIndex + 1) isSeparator ifTrue: [
											[ leftIndex < string size and: [ (string at: leftIndex + 1) isSeparator ] ] whileTrue: [ leftIndex := leftIndex + 1 ].
										] ifFalse: [
											| newLeftIndex |
											newLeftIndex := leftIndex.
											[ newLeftIndex >= startIndex and: [ (string at: newLeftIndex) isSeparator not ] ] whileTrue: [ newLeftIndex := newLeftIndex - 1 ].
											(x > dc leftInset or: [ newLeftIndex > startIndex ]) ifTrue: [
												leftIndex := newLeftIndex ] ] ].
									drawnString := string copyFrom: startIndex to: leftIndex.
									drawnStringStream nextPut: drawnString.
									textWidth := dc fontStruct textWidth: drawnString.
									x := x + textWidth.
									startIndex := leftIndex + 1.
									startIndex <= string size ifTrue: [
										x := dc leftInset ] ] ]) ]
						separatedBy: [
							| newX |
							newX := x - dc leftInset // dc tabWidth + 1 * dc tabWidth + dc leftInset.
							x := newX.
							x > (drawingArea width - dc rightInset) ifTrue: [
								x := dc leftInset ] ] ]) ]
			separatedBy: [
				x := dc leftInset ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> linkColor [

	^ Color darkBlue
]

{ #category : 'Not categorized' }
GeminiChatWidget >> pointedToCodeElementReferencingClassNameColor [

	^ self pointedToLinkColor
]

{ #category : 'Not categorized' }
GeminiChatWidget >> pointedToCodeTextBlockColor [

	^ Color red: (230 bitShift: 8) green: (240 bitShift: 8) blue: (250 bitShift: 8)
]

{ #category : 'Not categorized' }
GeminiChatWidget >> pointedToLinkColor [

	^ Color blue
]

{ #category : 'Not categorized' }
GeminiChatWidget >> removeSelectionScrollTimeout [

	selectionScrollTimeoutID ifNotNil: [
		CwAppContext default removeTimeout: selectionScrollTimeoutID.
		selectionScrollTimeoutID := nil ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> resetTextSegmentLayout [

	CwAppContext default asyncExecInUI: [
		chat resetTextSegmentLayout.
		selecting := false.
		self removeSelectionScrollTimeout.
		selectionStartPoint := nil.
		selectionEndPoint := nil.
		drawingArea redraw ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> scrollBarValueChanged: ignored clientData: clientData callData: callData [

	drawingArea redraw
]

{ #category : 'Not categorized' }
GeminiChatWidget >> scrollToNextUserMessage [

	scrollBarMinMaxValue := scrollBarNextMinMaxValue.
	scrollBar maximum: scrollBarMinMaxValue + drawingArea height + scrollBarValueFactor - 1 // scrollBarValueFactor.
	scrollBar value: scrollBarMinMaxValue // scrollBarValueFactor.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> scrolledWindowDestroyed: scrolledWindow clientData: clientData callData: callData [

	self removeSelectionScrollTimeout.
	chat ifNotNil: [
		chat removeDependent: self ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> scrolledWindowExposedOrResized: scrolledWindow clientData: clientData callData: callData [

	chat resetTextSegmentLayout.
	selectionStartPoint := nil.
	selectionEndPoint := nil.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> selectedString [

	^ selectedString
]

{ #category : 'Not categorized' }
GeminiChatWidget >> selectionScrollTimeoutElapsed: clientData [

	| relativeSelectionEndY distanceSelectionEndY valueDelta previousValue |

	selectionScrollTimeoutID := nil.
	(selecting and: [ selectionEndPoint notNil ]) ifFalse: [ ^ self ].
	relativeSelectionEndY := selectionEndPoint y - (scrollBar value * scrollBarValueFactor).
	(relativeSelectionEndY between: 0 and: drawingArea height) ifTrue: [ ^ self ].
	distanceSelectionEndY := relativeSelectionEndY negative ifTrue: [ relativeSelectionEndY abs ] ifFalse: [ relativeSelectionEndY - drawingArea height ].
	valueDelta := ((distanceSelectionEndY // 4 min: scrollBar pageIncrement * scrollBarValueFactor) max: scrollBarValueFactor) * relativeSelectionEndY sign.
	previousValue := scrollBar value * scrollBarValueFactor.
	scrollBar setValue: (previousValue + valueDelta) // scrollBarValueFactor notify: true.
	selectionEndPoint := selectionEndPoint + (0 @ (scrollBar value * scrollBarValueFactor - previousValue)).
	self addSelectionScrollTimeout
]

{ #category : 'Not categorized' }
GeminiChatWidget >> toggleIndicatorExpanded: isExpanded [

	^ UnicodeString value: (isExpanded ifTrue: [ 16r23F7 ] ifFalse: [ 16r23F5 ])
]

{ #category : 'Not categorized' }
GeminiChatWidget >> update: ignored [

	CwAppContext default asyncExecInUI: [
		drawingArea isRealized ifTrue: [
			drawingArea redraw ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> updateSelectionStartEndX: dc [

	selectionEndPoint ifNotNil: [
		dc selectionStartX: (selectionStartPoint y <= dc y ifTrue: [ dc leftInset ] ifFalse: [
			selectionStartPoint y < (dc y + dc ascent + dc descent) ifTrue: [ selectionStartPoint x ] ifFalse: [ Float infinity ] ]).
		dc selectionEndX: (selectionEndPoint y <= dc y ifTrue: [ dc leftInset ] ifFalse: [
			selectionEndPoint y < (dc y + dc ascent + dc descent) ifTrue: [ selectionEndPoint x ] ifFalse: [ Float infinity ] ]).
		dc selectionEndX < dc selectionStartX ifTrue: [
			| newStartX |
			newStartX := dc selectionEndX.
			dc selectionEndX: dc selectionStartX.
			dc selectionStartX: newStartX ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> userMessageBackgroundColor [

	^ Color gray: 0.97
]
