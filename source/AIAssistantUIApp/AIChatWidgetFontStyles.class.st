Class {
	#name : 'AIChatWidgetFontStyles',
	#superclass : 'Object',
	#instVars : [
		'normal',
		'bold',
		'italic',
		'boldItalic'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
AIChatWidgetFontStyles class >> normal: normal bold: bold italic: italic boldItalic: boldItalic [

	^ self basicNew initializeWithNormal: normal bold: bold italic: italic boldItalic: boldItalic
]

{ #category : 'Not categorized' }
AIChatWidgetFontStyles class >> size: fontSize monospaced: useMonospacedFonts [

	| fontNameTemplate fontFamily additionalInfo fontSpacing fontStructs |

	fontNameTemplate := '-microsoft-%1-%2-%3-normal-%4-*-%5-*-*-%6-*-iso8859-1'.
	fontFamily := useMonospacedFonts ifTrue: [ 'consolas' ] ifFalse: [ 'segoe ui' ].
	additionalInfo := useMonospacedFonts ifTrue: [ '' ] ifFalse: [ 'sans serif' ].
	fontSpacing := useMonospacedFonts ifTrue: [ 'm' ] ifFalse: [ 'p' ].
	fontStructs := #('medium' 'bold') collect: [ :fontWeight | #('r' 'i') collect: [ :fontSlant |
		CgDisplay default loadQueryFont: (fontNameTemplate bindWith: fontFamily with: fontWeight with: fontSlant with: additionalInfo with: fontSize with: fontSpacing) ] ].
	^ self normal: fontStructs first first bold: fontStructs second first italic: fontStructs first second boldItalic: fontStructs second second
]

{ #category : 'Not categorized' }
AIChatWidgetFontStyles >> bold [

	^ bold
]

{ #category : 'Not categorized' }
AIChatWidgetFontStyles >> boldItalic [

	^ boldItalic
]

{ #category : 'Not categorized' }
AIChatWidgetFontStyles >> freeFonts [

	normal freeFont.
	bold freeFont.
	italic freeFont.
	boldItalic freeFont.
]

{ #category : 'Not categorized' }
AIChatWidgetFontStyles >> initializeWithNormal: initialNormal bold: initialBold italic: initialItalic boldItalic: initialBoldItalic [

	self initialize.
	normal := initialNormal.
	bold := initialBold.
	italic := initialItalic.
	boldItalic := initialBoldItalic.
]

{ #category : 'Not categorized' }
AIChatWidgetFontStyles >> italic [

	^ italic
]

{ #category : 'Not categorized' }
AIChatWidgetFontStyles >> normal [

	^ normal
]
