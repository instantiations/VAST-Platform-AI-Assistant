Class {
	#name : 'GeminiTextElementSequence',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'elements'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextElementSequence class >> elements: elements [

	^ self basicNew initializeWithElements: elements
]

{ #category : 'Not categorized' }
GeminiTextElementSequence class >> fromString: string [

	| elements delimiters currentIndex startIndex openingBrackets openerBottomIndexes |

	elements := OrderedCollection new.
	delimiters := OrderedCollection new.
	currentIndex := 1.
	startIndex := 1.
	openingBrackets := OrderedCollection new.
	[ currentIndex <= string size ] whileTrue: [
		| character |
		character := string at: currentIndex.
		(character = $[ or: [ character = $] or: [ character = $` or: [ character = $* ] ] ]) ifTrue: [
			character = $[ ifTrue: [
				currentIndex > startIndex ifTrue: [
					elements add: (GeminiTextElementString string: (string copyFrom: startIndex to: currentIndex - 1)) ].
				elements add: (GeminiTextElementString string: '[').
				openingBrackets add: { currentIndex + 1. elements size. delimiters size }.
				startIndex := currentIndex + 1.
				currentIndex := startIndex
			] ifFalse: [
				character = $] ifTrue: [
					(openingBrackets ifEmpty: [ nil ] ifNotEmpty: [ (currentIndex < string size and: [ (string at: currentIndex + 1) = $( ]) ifTrue: [ (currentIndex + 2 to: string size) detect: [ :index | (string at: index) = $) ] ifNone: [ nil ] ] ]) ifNotNil: [ :stopIndex |
						| linkTextSequence |
						linkTextSequence := self fromString: (string copyFrom: openingBrackets last first to: currentIndex - 1).
						elements at: openingBrackets last second put: (GeminiTextElementLink element: linkTextSequence destination: (string copyFrom: currentIndex + 2 to: stopIndex - 1)).
						elements replaceFrom: openingBrackets last second + 1 to: elements size withObject: nil.
						[ delimiters size > openingBrackets last third ] whileTrue: [ delimiters removeLast ].
						openingBrackets := OrderedCollection new.
						startIndex := stopIndex + 1.
						currentIndex := startIndex
					] ifNil: [
						openingBrackets ifNotEmpty: [ openingBrackets removeLast ].
						currentIndex := currentIndex + 1 ]
				] ifFalse: [
					character = $` ifTrue: [
						| stopIndex |
						stopIndex := (currentIndex + 1 to: string size) detect: [ :index | (string at: index) ~= $` ] ifNone: [ string size + 1 ].
						((stopIndex to: string size + 1 - (stopIndex - currentIndex)) detect: [ :index | (index to: index + (stopIndex - currentIndex) - 1) allSatisfy: [ :index2 | (string at: index2) = $` ] ] ifNone: [ nil ]) ifNil: [
							currentIndex := currentIndex + 1
						] ifNotNil: [ :codeStopIndex |
							| code |
							currentIndex > startIndex ifTrue: [
								elements add: (GeminiTextElementString string: (string copyFrom: startIndex to: currentIndex - 1)) ].
							code := string copyFrom: stopIndex to: codeStopIndex - 1.
							((code first = Character space) and: [ code last = Character space and: (code anySatisfy: [ :codeCharacter | codeCharacter ~= Character space ]) ]) ifTrue: [
								code := code copyFrom: 2 to: code size - 1 ].
							elements add: (GeminiTextElementCode code: code).
							startIndex := codeStopIndex + (stopIndex - currentIndex).
							currentIndex := startIndex ]
					] ifFalse: [
						| stopIndex |
						currentIndex > startIndex ifTrue: [
							elements add: (GeminiTextElementString string: (string copyFrom: startIndex to: currentIndex - 1)) ].
						stopIndex := (currentIndex + 1 to: string size) detect: [ :index | (string at: index) ~= $* ] ifNone: [ string size + 1 ].
						delimiters add: (elements add: (GeminiTextElementString string: (string copyFrom: currentIndex to: stopIndex - 1))) -> {
							(stopIndex <= string size) and: [ (string at: stopIndex) ~= Character space ].
							currentIndex > 1 and: [ (string at: currentIndex - 1) ~= Character space ].
							stopIndex - currentIndex }.
						startIndex := stopIndex.
						currentIndex := startIndex ] ] ]
		] ifFalse: [
			currentIndex := currentIndex + 1 ] ].
	currentIndex > startIndex ifTrue: [
		elements add: (GeminiTextElementString string: (string copyFrom: startIndex to: currentIndex - 1)) ].
	
	openerBottomIndexes := Dictionary new.
	currentIndex := 1.
	[ (currentIndex := (currentIndex to: delimiters size) detect: [ :index | (delimiters at: index) value second ] ifNone: [ nil ]) notNil ] whileTrue: [
		| closingDelimiter openerBottomIndex openerIndex |
		closingDelimiter := delimiters at: currentIndex.
		openerBottomIndex := openerBottomIndexes at: { closingDelimiter value first. closingDelimiter value third \\ 3 } ifAbsent: [ 0 ].
		openerIndex := (currentIndex - 1 to: openerBottomIndex + 1 by: -1) detect: [ :index |
			| delimiter |
			delimiter := delimiters at: index.
			delimiter value first and: [
				((closingDelimiter value first or: [ delimiter value second ]) and: [
					(closingDelimiter value third \\ 3 ~= 0) and: [
						(delimiter value third + closingDelimiter value third) \\ 3 = 0 ] ]) not ] ] ifNone: [ nil ].
		openerIndex ifNotNil: [
			| openingDelimiter isStrong openingElementIndex closingElementIndex |
			openingDelimiter := delimiters at: openerIndex.
			isStrong := openingDelimiter key string size >= 2 and: [ closingDelimiter key string size >= 2 ].
			[ currentIndex > (openerIndex + 1) ] whileTrue: [
				delimiters removeAtIndex: (currentIndex := currentIndex - 1) ].
			openingDelimiter key string: (openingDelimiter key string copyFrom: 1 to: openingDelimiter key string size - (isStrong ifTrue: [ 2 ] ifFalse: [ 1 ])).
			closingDelimiter key string: (closingDelimiter key string copyFrom: 1 to: closingDelimiter key string size - (isStrong ifTrue: [ 2 ] ifFalse: [ 1 ])).
			openingElementIndex := (1 to: elements size) detect: [ :index | (elements at: index) == openingDelimiter key ].
			closingElementIndex := (1 to: elements size) detect: [ :index | (elements at: index) == closingDelimiter key ].
			elements at: openingElementIndex + 1 put: (GeminiTextElementEmphasis isStrong: isStrong
				element: (GeminiTextElementSequence elements:
					((elements copyFrom: openingElementIndex + 1 to: closingElementIndex -1) reject: [ :element | element isNil ]))).
			elements replaceFrom: openingElementIndex + 2 to: closingElementIndex - 1 withObject: nil.
			openingDelimiter key string ifEmpty: [
				delimiters removeAtIndex: openerIndex.
				currentIndex := currentIndex - 1.
				elements at: openingElementIndex put: nil ].
			closingDelimiter key string ifEmpty: [
				delimiters removeAtIndex: currentIndex.
				elements at: closingElementIndex put: nil ].
		] ifNil: [
			openerBottomIndexes at: { closingDelimiter value first. closingDelimiter value third \\ 3 } put: currentIndex - 1.
			closingDelimiter value first ifFalse: [
				delimiters removeAtIndex: currentIndex
			] ifTrue: [
				currentIndex := currentIndex + 1 ] ] ].

	^ self elements: (elements reject: [ :element | element isNil ])
]

{ #category : 'Not categorized' }
GeminiTextElementSequence class >> new [

	^ self elements: OrderedCollection new
]

{ #category : 'Not categorized' }
GeminiTextElementSequence >> = object [

	^ self class = object class and: [ self elements = object elements ]
]

{ #category : 'Not categorized' }
GeminiTextElementSequence >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementSequence: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementSequence >> elements [

	^ elements
]

{ #category : 'Not categorized' }
GeminiTextElementSequence >> initializeWithElements: initialElements [

	self initialize.
	elements := initialElements.
]

{ #category : 'Not categorized' }
GeminiTextElementSequence >> isSequenceElement [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextElementSequence >> resetLayout [

	self elements do: [ :element | element resetLayout ]
]
