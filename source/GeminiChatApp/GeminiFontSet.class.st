Class {
	#name : 'GeminiFontSet',
	#superclass : 'Object',
	#instVars : [
		'normal',
		'bold',
		'italic',
		'boldItalic'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFontSet class >> normal: normal bold: bold italic: italic boldItalic: boldItalic [

	^ self basicNew initializeWithNormal: normal bold: bold italic: italic boldItalic: boldItalic
]

{ #category : 'Not categorized' }
GeminiFontSet class >> size: fontSize [

	| fontNameTemplate fontStructs |

	fontNameTemplate := '-microsoft-segoe ui-%1-%2-normal-sans serif-*-%3-*-*-p-*-iso8859-1'.
	fontStructs := #('medium' 'bold') collect: [ :fontWeight | #('r' 'i') collect: [ :fontSlant |
		CgDisplay default loadQueryFont: (fontNameTemplate bindWith: fontWeight with: fontSlant with: fontSize) ] ].
	^ self normal: fontStructs first first bold: fontStructs second first italic: fontStructs first second boldItalic: fontStructs second second
]

{ #category : 'Not categorized' }
GeminiFontSet >> bold [

	^ bold
]

{ #category : 'Not categorized' }
GeminiFontSet >> boldItalic [

	^ boldItalic
]

{ #category : 'Not categorized' }
GeminiFontSet >> freeFonts [

	normal freeFont.
	bold freeFont.
	italic freeFont.
	boldItalic freeFont.
]

{ #category : 'Not categorized' }
GeminiFontSet >> initializeWithNormal: initialNormal bold: initialBold italic: initialItalic boldItalic: initialBoldItalic [

	self initialize.
	normal := initialNormal.
	bold := initialBold.
	italic := initialItalic.
	boldItalic := initialBoldItalic.
]

{ #category : 'Not categorized' }
GeminiFontSet >> italic [

	^ italic
]

{ #category : 'Not categorized' }
GeminiFontSet >> normal [

	^ normal
]
