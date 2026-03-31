Class {
	#name : 'GeminiTextBlockListItem',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'marker',
		'indentationLevel',
		'sequenceBlock'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockListItem class >> marker: marker indentationLevel: indentationLevel [

	^ self basicNew initializeWithMarker: marker indentationLevel: indentationLevel
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem class >> startingAtLine: line [

	| markerIndex marker contentIndex |

	markerIndex := (1 to: (4 min: line size - 1)) detect: [ :index | (marker := line at: index) ~= Character space ] ifNone: [ ^ nil ].
	(#($* $- $+) includes: marker) ifFalse: [ ^ nil ].
	(line at: markerIndex + 1) = Character space ifFalse: [ ^ nil ].
	contentIndex := (markerIndex + 2 to: (markerIndex + 5 min: line size)) detect: [ :index | (line at: index) ~= Character space ] ifNone: [ ^ nil ].
	^ self marker: marker indentationLevel: contentIndex - 1
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> = object [

	^ self class = object class and: [ self sequenceBlock = object sequenceBlock ]
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockListItem: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> initializeWithMarker: initialMarker indentationLevel: initialIndentationLevel [

	self initialize.
	marker := initialMarker.
	indentationLevel := initialIndentationLevel.
	sequenceBlock := GeminiTextBlockSequence new.
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> isListItemBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> lineWithoutStartMarker: line [

	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> markerString [

	^ UnicodeString value: '\u{2022}'
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> matchLine: line [

	1 to: (line size min: indentationLevel) do: [ :index |
		(line at: index) = Character space ifFalse: [ ^ nil ] ].
	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> resetLayout [

	self sequenceBlock resetLayout
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Not categorized' }
GeminiTextBlockListItem >> textElement [

	self shouldNotImplement
]
