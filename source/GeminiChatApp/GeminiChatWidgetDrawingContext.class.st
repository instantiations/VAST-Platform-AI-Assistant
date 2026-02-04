Class {
	#name : 'GeminiChatWidgetDrawingContext',
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
		'yOffset',
		'y',
		'pendingListBullets',
		'pendingListOrdinals',
		'pendingListMarkers',
		'textSegment',
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
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> ascent [
	^ascent
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> ascent: anObject [
	ascent := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> backgroundColor [
	^backgroundColor
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> backgroundColor: anObject [
	backgroundColor := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> baseLeftInset [
	^baseLeftInset
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> baseLeftInset: anObject [
	baseLeftInset := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> descent [
	^descent
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> descent: anObject [
	descent := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> fontSet [
	^fontSet
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> fontSet: anObject [
	fontSet := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> fontStruct [
	^fontStruct
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> fontStruct: anObject [
	fontStruct := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> gc [
	^gc
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> gc: anObject [
	gc := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> interactableAreas [
	^interactableAreas
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> interactableAreas: anObject [
	interactableAreas := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInset [
	^leftInset
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInset: anObject [
	leftInset := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInsetCodeBlockIncrement [
	^leftInsetCodeBlockIncrement
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInsetCodeBlockIncrement: anObject [
	leftInsetCodeBlockIncrement := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInsetListItemBlockIncrement [
	^leftInsetListItemBlockIncrement
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInsetListItemBlockIncrement: anObject [
	leftInsetListItemBlockIncrement := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInsetQuoteBlockIncrement [
	^leftInsetQuoteBlockIncrement
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> leftInsetQuoteBlockIncrement: anObject [
	leftInsetQuoteBlockIncrement := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> padding [
	^padding
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> padding: anObject [
	padding := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> pendingListMarkers [
	^pendingListMarkers
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> pendingListMarkers: anObject [
	pendingListMarkers := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> pixmap [
	^pixmap
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> pixmap: anObject [
	pixmap := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> rightInset [
	^rightInset
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> rightInset: anObject [
	rightInset := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> selectionEndX [
	^selectionEndX
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> selectionEndX: anObject [
	selectionEndX := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> selectionStartX [
	^selectionStartX
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> selectionStartX: anObject [
	selectionStartX := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> selectionStream [
	^selectionStream
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> selectionStream: anObject [
	selectionStream := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> tabWidth [
	^tabWidth
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> tabWidth: anObject [
	tabWidth := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textBolded [
	^textBolded
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textBolded: anObject [
	textBolded := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textColor [
	^textColor
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textColor: anObject [
	textColor := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textItalicized [
	^textItalicized
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textItalicized: anObject [
	textItalicized := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textSegment [
	^textSegment
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> textSegment: anObject [
	textSegment := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> withLeftInset: newValue do: block [

	| oldValue blockValue |

	oldValue := leftInset.
	leftInset := newValue.
	blockValue := block value.
	leftInset := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> withLeftInsetIncreasedBy: leftInsetIncrement do: block [

	^ self withLeftInset: leftInset + leftInsetIncrement do: block
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> withTextBolded: newValue do: block [

	| oldValue blockValue |

	oldValue := textBolded.
	textBolded := newValue.
	blockValue := block value.
	textBolded := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> withTextColor: newValue do: block [

	| oldValue blockValue |

	oldValue := textColor.
	textColor := newValue.
	blockValue := block value.
	textColor := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> withTextItalicized: newValue do: block [

	| oldValue blockValue |

	oldValue := textItalicized.
	textItalicized := newValue.
	blockValue := block value.
	textItalicized := oldValue.
	^ blockValue
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> x [
	^x
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> x: anObject [
	x := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> y [
	^y
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> y: anObject [
	y := anObject
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> yOffset [
	^yOffset
]

{ #category : 'Not categorized' }
GeminiChatWidgetDrawingContext >> yOffset: anObject [
	yOffset := anObject
]
