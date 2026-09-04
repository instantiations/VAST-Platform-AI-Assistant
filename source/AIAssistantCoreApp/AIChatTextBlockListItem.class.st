Class {
	#name : 'AIChatTextBlockListItem',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'marker',
		'indentationLevel',
		'sequenceBlock'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextBlockListItem class >> marker: marker indentationLevel: indentationLevel [

	^ self basicNew initializeWithMarker: marker indentationLevel: indentationLevel
]

{ #category : 'Instantiation' }
AIChatTextBlockListItem class >> startingAtLine: line [

	| markerIndex marker contentIndex |

	markerIndex := (1 to: (4 min: line size - 1)) detect: [ :index | (marker := line at: index) ~= Character space ] ifNone: [ ^ nil ].
	(#($* $- $+) includes: marker) ifFalse: [ ^ nil ].
	(line at: markerIndex + 1) = Character space ifFalse: [ ^ nil ].
	contentIndex := (markerIndex + 2 to: (markerIndex + 5 min: line size)) detect: [ :index | (line at: index) ~= Character space ] ifNone: [ ^ nil ].
	^ self marker: marker indentationLevel: contentIndex - 1
]

{ #category : 'Comparing' }
AIChatTextBlockListItem >> = object [

	^ self class = object class and: [ self sequenceBlock = object sequenceBlock ]
]

{ #category : 'Accessing' }
AIChatTextBlockListItem >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Initialization' }
AIChatTextBlockListItem >> initializeWithMarker: initialMarker indentationLevel: initialIndentationLevel [

	self initialize.
	marker := initialMarker.
	indentationLevel := initialIndentationLevel.
	sequenceBlock := AIChatTextBlockSequence new.
]

{ #category : 'Testing' }
AIChatTextBlockListItem >> isListItemBlock [

	^ true
]

{ #category : 'Parsing' }
AIChatTextBlockListItem >> lineWithoutStartMarker: line [

	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Accessing' }
AIChatTextBlockListItem >> markerString [

	^ UnicodeString value: '\u{2022}'
]

{ #category : 'Parsing' }
AIChatTextBlockListItem >> matchLine: line [

	1 to: (line size min: indentationLevel) do: [ :index |
		(line at: index) = Character space ifFalse: [ ^ nil ] ].
	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Accessing' }
AIChatTextBlockListItem >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Accessing' }
AIChatTextBlockListItem >> textElement [

	self shouldNotImplement
]
