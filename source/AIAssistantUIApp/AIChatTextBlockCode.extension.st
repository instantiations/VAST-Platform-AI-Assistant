Extension {
	#name : 'AIChatTextBlockCode'
}

{ #category : 'Interactions' }
AIChatTextBlockCode >> browse [

	self 
		resolveExistingMethod: [:method | 
			^self 
				openMergeWindowForClass: method methodClass 
				selector: method selector 
				currentSource: method sourceString] 
		newMethod: [:class :selector | 
			^self 
				openMergeWindowForClass: class 
				selector: selector 
				currentSource: ''].
				
	self 
		resolveExistingClass: [:class | 
			^self 
				openMergeWindowForClassDefinition: class 
				currentSource: class definitionString] 
		newClass: [:className | 
			^self 
				openMergeWindowForClassDefinition: nil 
				currentSource: ''].

	"Fallback to a workspace when were not able to identify a class or method."
	StsWorkspace stsPrompt: 'AI Assistant Workspace' default: self code
]

{ #category : 'Interactions' }
AIChatTextBlockCode >> buttonPressedIn: chatWidget [

	CwAppContext default asyncExecInUI: [
		self browse ]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatTextBlockCode >> classMatcher [

	^ '^\w+\s+\w*subclass\:\s*#(\w+).*' asRegex.
]

{ #category : 'Not categorized' }
AIChatTextBlockCode >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockCode: self dc: dc
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatTextBlockCode >> methodHeaderStartPositionIn: aString [
	|indexOfSeparator|
	indexOfSeparator := aString indexOfSubCollection: '>>' ifAbsent: [ Error signal: 'Method header separator ''>>'' not found.' ].
	^ indexOfSeparator + 2
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatTextBlockCode >> methodMatcher [

	^'^(\w+)\s*(class)?\s*>>\s*(.+)$' asRegex
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIChatTextBlockCode >> openMergeWindowForClass: aClass selector: aSelector currentSource: currentSourceString [
	"Open a code merge window. If currentSourceString is empty, it acts as a new method."

	| newSource |
	newSource := self code.
	"Extract the source code following the class definition pattern"
	AICodeMergeWindow
		openOn: currentSourceString
		and: (newSource copyFrom: (self methodHeaderStartPositionIn: newSource) to: newSource size)
		forClass: aClass
		selector: aSelector
]

{ #category : 'Not categorized' }
AIChatTextBlockCode >> openMergeWindowForClassDefinition: aClass currentSource: currentSourceString [
	"Open a code merge window for a class definition."

	AICodeMergeWindow
		openOn: currentSourceString
		and: self code
		forClass: aClass
		selector: nil
]

{ #category : 'Interactions' }
AIChatTextBlockCode >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Interactions' }
AIChatTextBlockCode >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextBlockCode >> resolveExistingClass: existingBlock newClass: newBlock [
	"If this code block represents a class definition:
		- and there is an existing class, execute the @existingBlock with the existing class as argument and return the result.
		- but if the class does not exist, execute the @newBlock with the class name as argument and return the result.
	If this code is not a class definition: return nil."

	| matcher line className class |

	self code isEmpty ifTrue: [^nil].
	line := self code lines first.
	matcher := self classMatcher.
	(matcher matches: line)
		ifTrue: [
			className := matcher subexpression: 2.
			class := Smalltalk at: className asSymbol ifAbsent: [nil].
			^ class 
				ifNil: [ newBlock value: className asSymbol ]
				ifNotNil: [ existingBlock value: class ] ].
	^nil
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatTextBlockCode >> resolveExistingMethod: existingBlock newMethod: newBlock [
	"If this code block represents a method:
		- and there is an existing method, execute the @existingBlock with the existing method as argument and return the result.
		- but if the method does not exist, but the class does, execute the @newBlock with the class and selector as arguments and return the result.
	If this code is not a method: return nil."
	| matcher line className selector class |

	self code isEmpty ifTrue: [^nil].
	line := self code lines first.
	matcher := self methodMatcher.
	(matcher matches: line)
		ifTrue: [ |isMeta|
			className := matcher subexpression:  2.
			isMeta := (matcher subexpression:  3) = 'class'.
			"keyword selector"
			selector := String streamContents: [:selectorStream |
			(matcher subexpression: 4) subStrings
				do: [:t | (t last = $:) ifTrue: [selectorStream nextPutAll: t]]].
			"binary selector"
			selector isEmpty ifTrue: [selector := (matcher subexpression: 4) subStrings first].
			class := Smalltalk at: className asSymbol ifAbsent: [nil].
			class ifNotNil: [ | method | 
				isMeta ifTrue: [class := class class].
				method := class compiledMethodAt: selector asSymbol ifAbsent: [nil].
				^ method 
					ifNil: [ newBlock value: class value: selector asSymbol ]
					ifNotNil:[ existingBlock value: method ]]].
	^nil
]
