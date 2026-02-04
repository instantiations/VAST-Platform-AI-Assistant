Class {
	#name : 'GeminiTextBlockCode',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'code',
		'isPointedTo'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockCode class >> code: code [

	^ self basicNew initializeWithCode: code
]

{ #category : 'Interactions' }
GeminiTextBlockCode >> browse [

	| method class |
	method := self resolveMethod.
	method
		ifNotNil: [ self openComparisonBrowserOn: method. ^ self ].
	class := self resolveClass.
	class ifNotNil: [ class browse. ^ self ].
	"Fallback to a workspace when were not able to identify a class or method."
	StsWorkspace stsPrompt: 'Gemini' default: self code.
]

{ #category : 'Not categorized' }
GeminiTextBlockCode >> buttonPressedIn: chatWidget [

	CwAppContext default asyncExecInUI: [
		self browse ]
]

{ #category : 'Accessing' }
GeminiTextBlockCode >> code [

	^ code
]

{ #category : 'Not categorized' }
GeminiTextBlockCode >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockCode: self dc: dc
]

{ #category : 'Initialization' }
GeminiTextBlockCode >> initializeWithCode: initialCode [

	self initialize.
	code := initialCode.
	isPointedTo := false.
]

{ #category : 'Accessing' }
GeminiTextBlockCode >> isCodeBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockCode >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Interactions',
  #vaVisibility : 'private' }
GeminiTextBlockCode >> openComparisonBrowserOn: aMethod [

	| browser currentSource newSource className |

	currentSource := aMethod sourceString.
	newSource := self code.
	className := aMethod methodClass name.
	"Extract the source code following the class definition pattern"
	browser := ((EtTools browser: #textComparison)
		on: currentSource
		and: (newSource copyFrom: className size + 3 to: newSource size)).
	browser
		owningImage: System image;
		selectedMethod: aMethod.
	browser open
]

{ #category : 'Not categorized' }
GeminiTextBlockCode >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextBlockCode >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Interactions',
  #vaVisibility : 'private' }
GeminiTextBlockCode >> resolveClass [

	| matcher line className |

	self code isEmpty ifTrue: [^nil].
	line := self code lines first.
	matcher := '^\w+\s+\w*subclass\:\s*#(\w+).*' asRegex.
	(matcher matches: line)
		ifTrue: [
			"Subexpression 2 corresponds to the class name capture group"
			className := matcher subexpression: 2.
			^Smalltalk at: className asSymbol ifAbsent: [nil]].
	^nil
]

{ #category : 'Interactions',
  #vaVisibility : 'private' }
GeminiTextBlockCode >> resolveMethod [

	| matcher line className selector class |

	self code isEmpty ifTrue: [^nil].
	line := self code lines first.
	matcher := '^(\w+)\s*>>\s*(.+)$' asRegex.
	(matcher matches: line)
		ifTrue: [
			className := matcher subexpression: 2.
			selector := String new.
			(matcher subexpression: 3) subStrings
				do: [:t | (t last = $:) ifTrue: [selector := selector , t]].
			selector isEmpty ifTrue: [selector := (matcher subexpression: 3) subStrings first].
			class := Smalltalk at: className asSymbol ifAbsent: [nil].
			class ifNotNil: [^class compiledMethodAt: selector asSymbol ifAbsent: [nil]]].
	^nil
]

{ #category : 'Accessing' }
GeminiTextBlockCode >> textElement [

	^ GeminiTextElementString string: code
]
