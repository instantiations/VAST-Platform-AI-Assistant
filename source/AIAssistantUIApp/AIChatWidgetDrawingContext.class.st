Class {
	#name : 'AIChatWidgetDrawingContext',
	#superclass : 'Object',
	#instVars : [
		'pixmap',
		'gc',
		'tabWidth',
		'baseLeftInset',
		'leftInset',
		'leftInsetCodeBlockIncrement',
		'leftInsetQuoteBlockIncrement',
		'leftInsetListItemBlockIncrement',
		'rightInset',
		'textColor',
		'textBolded',
		'textItalicized',
		'textMonospaced',
		'yOffset',
		'y',
		'pendingListBullets',
		'pendingListOrdinals',
		'pendingListMarkers',
		'textSegment',
		'textElementLink',
		'backgroundColor',
		'padding',
		'fontSet',
		'fontStruct',
		'ascent',
		'descent',
		'x',
		'selectionStartX',
		'selectionEndX',
		'interactableAreas',
		'selectionStream'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> ascent [
	^ascent
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> ascent: anObject [
	ascent := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> backgroundColor [
	^backgroundColor
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> baseLeftInset [
	^baseLeftInset
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> baseLeftInset: anObject [
	baseLeftInset := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> descent [
	^descent
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> descent: anObject [
	descent := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> fontSet [
	^fontSet
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> fontSet: anObject [
	fontSet := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> fontStruct [
	^fontStruct
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> fontStruct: anObject [
	fontStruct := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> gc [
	^gc
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> gc: anObject [
	gc := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> interactableAreas [
	^interactableAreas
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> interactableAreas: anObject [
	interactableAreas := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInset [
	^leftInset
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInset: anObject [
	leftInset := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInsetCodeBlockIncrement [
	^leftInsetCodeBlockIncrement
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInsetCodeBlockIncrement: anObject [
	leftInsetCodeBlockIncrement := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInsetListItemBlockIncrement [
	^leftInsetListItemBlockIncrement
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInsetListItemBlockIncrement: anObject [
	leftInsetListItemBlockIncrement := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInsetQuoteBlockIncrement [
	^leftInsetQuoteBlockIncrement
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> leftInsetQuoteBlockIncrement: anObject [
	leftInsetQuoteBlockIncrement := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> padding [
	^padding
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> padding: anObject [
	padding := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> pendingListMarkers [
	^pendingListMarkers
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> pendingListMarkers: anObject [
	pendingListMarkers := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> pixmap [
	^pixmap
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> pixmap: anObject [
	pixmap := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> rightInset [
	^rightInset
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> rightInset: anObject [
	rightInset := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> selectionEndX [
	^selectionEndX
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> selectionEndX: anObject [
	selectionEndX := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> selectionStartX [
	^selectionStartX
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> selectionStartX: anObject [
	selectionStartX := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> selectionStream [
	^selectionStream
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> selectionStream: anObject [
	selectionStream := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> tabWidth [
	^tabWidth
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> tabWidth: anObject [
	tabWidth := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textBolded [
	^textBolded
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textBolded: anObject [
	textBolded := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textColor [
	^textColor
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textColor: anObject [
	textColor := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textElementLink [
	^textElementLink
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textElementLink: anObject [
	textElementLink := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textItalicized [
	^textItalicized
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textItalicized: anObject [
	textItalicized := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textMonospaced [
	^textMonospaced
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textMonospaced: anObject [
	textMonospaced := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textSegment [
	^textSegment
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> textSegment: anObject [
	textSegment := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> withLeftInset: newValue do: block [

	| oldValue blockValue |

	oldValue := leftInset.
	leftInset := newValue.
	blockValue := block value.
	leftInset := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> withLeftInsetIncreasedBy: leftInsetIncrement do: block [

	^ self withLeftInset: leftInset + leftInsetIncrement do: block
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> withTextBolded: newValue do: block [

	| oldValue blockValue |

	oldValue := textBolded.
	textBolded := newValue.
	blockValue := block value.
	textBolded := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> withTextColor: newValue do: block [

	| oldValue blockValue |

	oldValue := textColor.
	textColor := newValue.
	blockValue := block value.
	textColor := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> withTextElementLink: newValue do: block [

	| oldValue blockValue |

	oldValue := textElementLink.
	textElementLink := newValue.
	blockValue := block value.
	textElementLink := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> withTextItalicized: newValue do: block [

	| oldValue blockValue |

	oldValue := textItalicized.
	textItalicized := newValue.
	blockValue := block value.
	textItalicized := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> withTextMonospaced: newValue do: block [

	| oldValue blockValue |

	oldValue := textMonospaced.
	textMonospaced := newValue.
	blockValue := block value.
	textMonospaced := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> x [
	^x
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> x: anObject [
	x := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> y [
	^y
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> y: anObject [
	y := anObject
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> yOffset [
	^yOffset
]

{ #category : 'Not categorized' }
AIChatWidgetDrawingContext >> yOffset: anObject [
	yOffset := anObject
]
