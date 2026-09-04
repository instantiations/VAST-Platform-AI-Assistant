Class {
	#name : 'AIChatTextElementSequence',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'elements'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextElementSequence class >> elements: elements [

	^ self basicNew initializeWithElements: elements
]

{ #category : 'Instantiation' }
AIChatTextElementSequence class >> fromElements: elements [

	| mergedElements pendingStringElementStrings |

	mergedElements := OrderedCollection new.
	pendingStringElementStrings := OrderedCollection new.
	elements do: [ :element |
		element ifNotNil: [
			element isStringElement ifTrue: [
				pendingStringElementStrings add: element string
			] ifFalse: [
				pendingStringElementStrings ifNotEmpty: [
					mergedElements add: (AIChatTextElementString string: ('' join: pendingStringElementStrings)).
					pendingStringElementStrings removeAll ].
				mergedElements add: element ] ] ].
	pendingStringElementStrings ifNotEmpty: [
		mergedElements add: (AIChatTextElementString string: ('' join: pendingStringElementStrings)) ].
	^ self elements: mergedElements
]

{ #category : 'Instantiation' }
AIChatTextElementSequence class >> fromString: string [

	| characters escapableCharacters elements delimiters currentIndex startIndex openingBrackets openerBottomIndexes |

	characters := AIAbstractCharacterSequence string: string.
	escapableCharacters := Set withAll: '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~'.
	elements := OrderedCollection new.
	delimiters := OrderedCollection new.
	currentIndex := 1.
	startIndex := 1.
	openingBrackets := OrderedCollection new.
	[ currentIndex <= characters size ] whileTrue: [
		| character |
		character := characters at: currentIndex.
		character = $\ ifTrue: [
			currentIndex < characters size ifTrue: [
				| nextCharacter |
				nextCharacter := characters at: currentIndex + 1.
				(escapableCharacters includes: nextCharacter) ifTrue: [
					currentIndex > startIndex ifTrue: [
						elements add: (AIChatTextElementString string: (characters stringFrom: startIndex to: currentIndex - 1)) ].
					elements add: (AIChatTextElementString string: (String with: nextCharacter)).
					currentIndex := currentIndex + 2.
					startIndex := currentIndex
				] ifFalse: [
					currentIndex := currentIndex + 1 ]
			] ifFalse: [
				currentIndex := currentIndex + 1 ]
		] ifFalse: [
			(character = $[ or: [ character = $] or: [ character = $` or: [ character = $* ] ] ]) ifTrue: [
				character = $[ ifTrue: [
					currentIndex > startIndex ifTrue: [
						elements add: (AIChatTextElementString string: (characters stringFrom: startIndex to: currentIndex - 1)) ].
					elements add: (AIChatTextElementString string: '[').
					openingBrackets add: { currentIndex + 1. elements size. delimiters size }.
					startIndex := currentIndex + 1.
					currentIndex := startIndex
				] ifFalse: [
					character = $] ifTrue: [
						(openingBrackets ifEmpty: [ nil ] ifNotEmpty: [ (currentIndex < characters size and: [ (characters at: currentIndex + 1) = $( ]) ifTrue: [ (currentIndex + 2 to: characters size) detect: [ :index | (characters at: index) = $) and: [ (index - ((index - 1 to: currentIndex + 1 by: -1) detect: [ :i | (characters at: i) ~= $\ ])) odd ] ] ifNone: [ nil ] ] ]) ifNotNil: [ :stopIndex |
							| linkTextSequence destination |
							linkTextSequence := self fromString: (characters stringFrom: openingBrackets last first to: currentIndex - 1).
							destination := String streamContents: [ :stream |
								| index |
								index := currentIndex + 2.
								[ index < stopIndex ] whileTrue: [
									| destChar |
									destChar := characters at: index.
									(destChar = $\ and: [ index + 1 < stopIndex and: [ escapableCharacters includes: (characters at: index + 1) ] ])
										ifTrue: [
											stream nextPut: (characters at: index + 1).
											index := index + 2 ]
										ifFalse: [
											stream nextPut: destChar.
											index := index + 1 ] ] ].
							elements at: openingBrackets last second put: (AIChatTextElementLink element: linkTextSequence destination: destination).
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
							| stopIndex codeStopIndex |
							stopIndex := (currentIndex + 1 to: characters size) detect: [ :index | (characters at: index) ~= $` ] ifNone: [ characters size + 1 ].
							codeStopIndex := (stopIndex to: characters size + 1 - (stopIndex - currentIndex))
								detect: [ :index | 
									(characters at: index - 1) ~= $` and: [
										((index to: index + (stopIndex - currentIndex) - 1) allSatisfy: [ :index2 | (characters at: index2) = $` ]) and: [
											(index + (stopIndex - currentIndex) > characters size or: [ (characters at: index + (stopIndex - currentIndex)) ~= $` ]) ] ] ]
								ifNone: [ nil ].
							codeStopIndex ifNil: [
								currentIndex := stopIndex
							] ifNotNil: [
								| code |
								currentIndex > startIndex ifTrue: [
									elements add: (AIChatTextElementString string: (characters stringFrom: startIndex to: currentIndex - 1)) ].
								code := characters stringFrom: stopIndex to: codeStopIndex - 1.
								((code first = Character space) and: [ code last = Character space and: (code anySatisfy: [ :codeCharacter | codeCharacter ~= Character space ]) ]) ifTrue: [
									code := code copyFrom: 2 to: code size - 1 ].
								elements add: (AIChatTextElementCode code: code).
								startIndex := codeStopIndex + (stopIndex - currentIndex).
								currentIndex := startIndex ]
						] ifFalse: [
							| stopIndex |
							currentIndex > startIndex ifTrue: [
								elements add: (AIChatTextElementString string: (characters stringFrom: startIndex to: currentIndex - 1)) ].
							stopIndex := (currentIndex + 1 to: characters size) detect: [ :index | (characters at: index) ~= $* ] ifNone: [ characters size + 1 ].
							delimiters add: (elements add: (AIChatTextElementString string: (characters stringFrom: currentIndex to: stopIndex - 1))) -> {
								(stopIndex <= characters size) and: [ (characters at: stopIndex) ~= Character space ].
								currentIndex > 1 and: [ (characters at: currentIndex - 1) ~= Character space ].
								stopIndex - currentIndex }.
							startIndex := stopIndex.
							currentIndex := startIndex ] ] ]
			] ifFalse: [
				currentIndex := currentIndex + 1 ] ] ].
	currentIndex > startIndex ifTrue: [
		elements add: (AIChatTextElementString string: (characters stringFrom: startIndex to: currentIndex - 1)) ].
	
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
			elements at: openingElementIndex + 1 put: (AIChatTextElementEmphasis isStrong: isStrong
				element: (self fromElements: (elements copyFrom: openingElementIndex + 1 to: closingElementIndex -1))).
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

	^ self fromElements: elements
]

{ #category : 'Instantiation' }
AIChatTextElementSequence class >> new [

	^ self elements: OrderedCollection new
]

{ #category : 'Comparing' }
AIChatTextElementSequence >> = object [

	^ self class = object class and: [ self elements = object elements ]
]

{ #category : 'Accessing' }
AIChatTextElementSequence >> elements [

	^ elements
]

{ #category : 'Initialization' }
AIChatTextElementSequence >> initializeWithElements: initialElements [

	self initialize.
	elements := initialElements.
]

{ #category : 'Testing' }
AIChatTextElementSequence >> isSequenceElement [

	^ true
]
