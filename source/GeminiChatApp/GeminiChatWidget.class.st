Class {
	#name : 'GeminiChatWidget',
	#superclass : 'CwExtendedPrimitive',
	#instVars : [
		'chat',
		'scrollBar',
		'drawingArea',
		'drawnInteractableAreas',
		'pointedToInteractableArea',
		'selecting',
		'selectionStartPoint',
		'selectionEndPoint',
		'selectedString'
	],
	#classVars : [
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

	^ 100
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
GeminiChatWidget >> drawingAreaButtonPress: ignored clientData: clientData callData: buttonEvent [

	| point |

	buttonEvent button = Button1 ifFalse: [ ^ self ].
	point := buttonEvent point + (0 @ scrollBar value).
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
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawingAreaExposed: ignored clientData: clientData callData: callData [

	| dc |

	(dc := GeminiChatWidgetDrawingContext new)
		pixmap: (drawingArea window createDpiPixmap: (DPIScaler autoScaleUp: drawingArea width drawable: drawingArea window)
			height: (DPIScaler autoScaleUp: callData event height drawable: drawingArea window) depth: drawingArea window depth);
		gc: (dc pixmap createGC: CgConstants::None values: nil);
		tabWidth: (self class baseFontSet normal textWidth: (String new: 4 withAll: Character space));
		baseLeftInset: 20;
		leftInset: dc baseLeftInset;
		leftInsetCodeBlockIncrement: dc tabWidth;
		leftInsetQuoteBlockIncrement: dc tabWidth;
		leftInsetListItemBlockIncrement: (self class baseFontSet normal textWidth: (String new: 8 withAll: Character space));
		rightInset: 20;
		yOffset: scrollBar value negated;
		y: self class baseFontSet normal height * 3 // 2;
		pendingListMarkers: OrderedCollection new;
		interactableAreas: OrderedCollection new;
		selectionStream: (WriteStream on: String new).
	dc pixmap setPalette: (CgIndexedPalette colors: CgIndexedPalette default colors , { Color selectionBackground. self userMessageBackgroundColor. self pointedToCodeTextBlockColor. Color lightGray }).
	dc gc setForeground: (dc pixmap getPalette nearestPixelValue: Color white).
	dc pixmap fillRectangle: dc gc x: 0 y: 0 width: dc pixmap width height: dc pixmap height.
	self drawTextSegments: dc.
	chat isActivelyGenerating ifTrue: [
		dc gc setFont: self class baseFontSet normal font; setForeground: (dc pixmap getPalette nearestPixelValue: Color darkGray).
		dc pixmap drawString: dc gc x: dc leftInset y: dc y + self class baseFontSet normal ascent + dc yOffset string: '...'.
		dc y: dc y + self class baseFontSet normal height ].
	dc pixmap copyArea: drawingArea window gc: dc gc srcX: callData event x srcY: 0
		srcWidth: drawingArea width srcHeight: callData event height
		destX: callData event x destY: callData event y destWidth: drawingArea width destHeight: callData event height.
	scrollBar
		maximum: dc y + (self class baseFontSet normal height * 3 // 2);
		sliderSize: drawingArea height;
		increment: self class baseFontSet normal height;
		pageIncrement: drawingArea height.
	drawnInteractableAreas := dc interactableAreas.
	selectedString := dc selectionStream contents.
	dc gc freeGC.
	dc pixmap freePixmap.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawingAreaPointerMotion: ignored clientData: clientData callData: motionEvent [

	| point |

	point := motionEvent point + (0 @ scrollBar value).
	selecting ifTrue: [
		selectionEndPoint := point.
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
GeminiChatWidget >> drawLeafTextBlock: textBlock dc: dc [

	dc fontSet: (textBlock isHeadingBlock ifTrue: [ self class headingFontSets at: (textBlock level min: self class headingFontSets size) ] ifFalse: [ self class baseFontSet ]).
	dc ascent: dc fontSet normal ascent.
	dc descent: dc fontSet normal descent.
	dc withTextBolded: textBlock isHeadingBlock do: [
		dc withTextItalicized: false do: [
			| startY |
			self drawPendingListMarkers: dc.
			self updateSelectionStartEndX: dc.
			startY := dc y.
			dc withLeftInsetIncreasedBy: (textBlock isCodeBlock ifTrue: [ dc leftInsetCodeBlockIncrement ] ifFalse: [ 0 ]) do: [
				dc x: dc leftInset.
				self drawTextElementOfTextBlock: textBlock dc: dc ].
			textBlock isCodeBlock ifTrue: [
				self drawMarkerTextBlockCode: textBlock startY: startY dc: dc ] ] ]
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
		dc gc setFont: self class baseFontSet normal font.
		dc gc setForeground: (dc pixmap getPalette nearestPixelValue: dc textColor).
		dc pixmap drawString: dc gc x: leftInset - (self class baseFontSet normal textWidth: markerString) y: dc y + dc ascent + dc yOffset string: markerString ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawString: textString dc: dc [

	dc fontStruct: (dc textBolded
		ifTrue: [ dc textItalicized ifTrue: [ dc fontSet boldItalic ] ifFalse: [ dc fontSet bold ] ]
		ifFalse: [ dc textItalicized ifTrue: [ dc fontSet italic ] ifFalse: [ dc fontSet normal ] ]).
	dc gc setFont: dc fontStruct font.
	(String crlf split: textString)
		do: [ :lineString |
			(Character tab split: lineString)
				do: [ :string |
					| startIndex |
					startIndex := 1.
					[ startIndex <= string size ] whileTrue: [
						| maxWidth leftIndex rightIndex distance drawnString |
						maxWidth := drawingArea width - dc rightInset - dc x.
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
								(dc x > dc leftInset or: [ newLeftIndex > startIndex ]) ifTrue: [
									leftIndex := newLeftIndex ] ] ].
						drawnString := string copyFrom: startIndex to: leftIndex.
						selectionEndPoint ifNotNil: [
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
						dc x: dc x + (dc fontStruct textWidth: drawnString).
						startIndex := leftIndex + 1.
						startIndex <= string size ifTrue: [
							dc x: dc leftInset.
							dc y: dc y + dc ascent + dc descent.
							dc ascent: dc fontStruct ascent.
							dc descent: dc fontStruct descent.
							self drawMiddleBackground: dc.
							self updateSelectionStartEndX: dc ] ] ]
				separatedBy: [
					| newX |
					newX := dc x - dc leftInset // dc tabWidth + 1 * dc tabWidth + dc leftInset.
					selectionEndPoint ifNotNil: [
						(dc x < dc selectionEndX and: [ newX > dc selectionStartX ]) ifTrue: [
							dc selectionStream tab.
							dc gc setForeground: (dc pixmap getPalette nearestPixelValue: Color selectionBackground).
							dc pixmap fillRectangle: dc gc x: dc x y: dc y + dc yOffset width: newX - dc x height: dc ascent + dc descent ] ].
					dc x: newX.
					dc x > (drawingArea width - dc rightInset) ifTrue: [
						dc x: dc leftInset.
						dc y: dc y + dc ascent + dc descent.
						dc ascent: dc fontStruct ascent.
						dc descent: dc fontStruct descent.
						self drawMiddleBackground: dc.
						self updateSelectionStartEndX: dc ] ] ]
		separatedBy: [
			selectionEndPoint ifNotNil: [
				(dc x >= dc selectionStartX and: [ dc x < dc selectionEndX ]) ifTrue: [
					dc selectionStream crlf ] ].
			dc x: dc leftInset.
			dc y: dc y + dc ascent + dc descent.
			dc ascent: dc fontStruct ascent.
			dc descent: dc fontStruct descent.
			self drawMiddleBackground: dc.
			self updateSelectionStartEndX: dc ].
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

	dc y: dc y + self class baseFontSet normal ascent + self class baseFontSet normal descent.
	startY := dc y.
	dc withTextColor: (textBlock isPointedTo ifTrue: [ Color gray ] ifFalse: [ Color darkGray ]) do: [
		self drawTextBlock: (GeminiTextBlockText text: (GeminiTextElementString string: 'Function calls: ' , (self toggleIndicatorExpanded: textBlock isExpanded))) dc: dc ].
	dc interactableAreas add: (GeminiChatWidgetInteractableArea rectangle: (Rectangle origin: dc leftInset @ startY corner: dc x @ dc y) handler: textBlock).
	textBlock isExpanded ifTrue: [
		| sequenceBlock |
		sequenceBlock := GeminiTextBlockSequence new.
		textBlock functionCalls do: [ :functionCall |
			sequenceBlock addBlock: ((GeminiTextBlockListItem marker: '*' indentationLevel: 2)
				addBlock: (GeminiTextBlockText text: (GeminiTextElementString string: functionCall name));
				yourself) ].
		dc withTextColor: Color darkGray do: [
			self drawTextBlock: sequenceBlock dc: dc ] ].
	dc y: dc y + self class baseFontSet normal ascent + self class baseFontSet normal descent.
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
GeminiChatWidget >> drawTextBlocksOfTextSegment: textSegment dc: dc [

	textSegment textBlocks do: [ :textBlock |
		self drawTextBlock: textBlock dc: dc ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextBlockText: textBlock dc: dc [

	self drawLeafTextBlock: textBlock dc: dc
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
			dc y: dc y + self class baseFontSet normal ascent + self class baseFontSet normal descent ] ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElement: textElement dc: dc [

	textElement drawOnChatWidget: self dc: dc
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementEmphasis: textElement dc: dc [

	textElement isStrong ifTrue: [
		dc withTextBolded: true do: [
			self drawTextElement: textElement element dc: dc ]
	] ifFalse: [
		dc withTextItalicized: true do: [
			self drawTextElement: textElement element dc: dc ] ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementOfTextBlock: textBlock dc: dc [

	| textElement |

	textElement := textBlock textElement.
	self drawMiddleBackground: dc.
	self drawTextElement: textElement dc: dc.
	selectionEndPoint ifNotNil: [
		(dc x >= dc selectionStartX and: [ dc x < dc selectionEndX ]) ifTrue: [
			dc selectionStream crlf ] ].
	dc y: dc y + dc ascent + dc descent.
	self updateSelectionStartEndX: dc.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementSequence: textElement dc: dc [

	textElement elements do: [ :containedTextElement |
		self drawTextElement: containedTextElement dc: dc ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> drawTextElementString: textElement dc: dc [

	self drawString: textElement string dc: dc
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
GeminiChatWidget >> drawTextSegments: dc [

	chat textSegments
		do: [ :textSegment |
			| textSegmentHeight |
			textSegmentHeight := textSegment height.
			(textSegmentHeight isNil or: [ 
				((dc y + textSegmentHeight) > scrollBar value and: [ dc y < (scrollBar value + drawingArea height) ]) or: [
					selectionEndPoint notNil and: [ (dc y + textSegmentHeight) > (selectionStartPoint y min: selectionEndPoint y) and: [ dc y < (selectionStartPoint y max: selectionEndPoint y) ] ] ] ])
						ifFalse: [
							dc y: dc y + textSegmentHeight
						] ifTrue: [
							textSegment height: (self drawTextSegment: textSegment dc: dc) ] ]
		separatedBy: [
			dc y: dc y + (self class baseFontSet normal height * 3 // 2) ].
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
GeminiChatWidget >> initialize [

	super initialize.
	selecting := false.
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
GeminiChatWidget >> pointedToCodeTextBlockColor [

	^ Color red: (230 bitShift: 8) green: (240 bitShift: 8) blue: (250 bitShift: 8)
]

{ #category : 'Not categorized' }
GeminiChatWidget >> resetTextSegmentHeights [

	CwAppContext default asyncExecInUI: [
		chat resetTextSegmentHeights.
		selecting := false.
		selectionStartPoint := nil.
		selectionEndPoint := nil.
		drawingArea redraw ].
]

{ #category : 'Not categorized' }
GeminiChatWidget >> scrollBarValueChanged: ignored clientData: clientData callData: callData [

	drawingArea redraw
]

{ #category : 'Not categorized' }
GeminiChatWidget >> scrolledWindowDestroyed: scrolledWindow clientData: clientData callData: callData [

	chat ifNotNil: [
		chat removeDependent: self ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> scrolledWindowExposedOrResized: scrolledWindow clientData: clientData callData: callData [

	chat resetTextSegmentHeights.
	selectionStartPoint := nil.
	selectionEndPoint := nil.
]

{ #category : 'Not categorized' }
GeminiChatWidget >> selectedString [

	^ selectedString
]

{ #category : 'Not categorized' }
GeminiChatWidget >> toggleIndicatorExpanded: isExpanded [

	^ UnicodeString value: (isExpanded ifTrue: [ 16r23F7 ] ifFalse: [ 16r23F5 ])
]

{ #category : 'Not categorized' }
GeminiChatWidget >> update: ignored [

	CwAppContext default asyncExecInUI: [
		drawingArea redraw ]
]

{ #category : 'Not categorized' }
GeminiChatWidget >> updateSelectionStartEndX: dc [

	selectionEndPoint ifNotNil: [
		dc selectionStartX: (selectionStartPoint y <= dc y ifTrue: [ dc leftInset ] ifFalse: [
			selectionStartPoint y < (dc y + dc ascent + dc descent) ifTrue: [ selectionStartPoint x ] ifFalse: [ drawingArea width - dc rightInset ] ]).
		dc selectionEndX: (selectionEndPoint y <= dc y ifTrue: [ dc leftInset ] ifFalse: [
			selectionEndPoint y < (dc y + dc ascent + dc descent) ifTrue: [ selectionEndPoint x ] ifFalse: [ drawingArea width - dc rightInset ] ]).
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
