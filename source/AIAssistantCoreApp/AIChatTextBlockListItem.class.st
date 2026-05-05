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

{ #category : 'Not categorized' }
AIChatTextBlockListItem class >> marker: marker indentationLevel: indentationLevel [

	^ self basicNew initializeWithMarker: marker indentationLevel: indentationLevel
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem class >> startingAtLine: line [

	| markerIndex marker contentIndex |

	markerIndex := (1 to: (4 min: line size - 1)) detect: [ :index | (marker := line at: index) ~= Character space ] ifNone: [ ^ nil ].
	(#($* $- $+) includes: marker) ifFalse: [ ^ nil ].
	(line at: markerIndex + 1) = Character space ifFalse: [ ^ nil ].
	contentIndex := (markerIndex + 2 to: (markerIndex + 5 min: line size)) detect: [ :index | (line at: index) ~= Character space ] ifNone: [ ^ nil ].
	^ self marker: marker indentationLevel: contentIndex - 1
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> = object [

	^ self class = object class and: [ self sequenceBlock = object sequenceBlock ]
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> initializeWithMarker: initialMarker indentationLevel: initialIndentationLevel [

	self initialize.
	marker := initialMarker.
	indentationLevel := initialIndentationLevel.
	sequenceBlock := AIChatTextBlockSequence new.
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> isListItemBlock [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> lineWithoutStartMarker: line [

	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> markerString [

	^ UnicodeString value: '\u{2022}'
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> matchLine: line [

	1 to: (line size min: indentationLevel) do: [ :index |
		(line at: index) = Character space ifFalse: [ ^ nil ] ].
	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Not categorized' }
AIChatTextBlockListItem >> textElement [

	self shouldNotImplement
]
