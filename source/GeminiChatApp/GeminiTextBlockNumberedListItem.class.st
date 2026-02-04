Class {
	#name : 'GeminiTextBlockNumberedListItem',
	#superclass : 'GeminiAbstractTextBlock',
	#instVars : [
		'number',
		'marker',
		'indentationLevel',
		'sequenceBlock'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem class >> number: number marker: marker indentationLevel: indentationLevel [

	^ self basicNew initializeWithNumber: number marker: marker indentationLevel: indentationLevel
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem class >> startingAtLine: line [

	| numberIndex digits firstDigit markerIndex marker contentIndex |

	numberIndex := (1 to: (4 min: line size - 3)) detect: [ :index | (firstDigit := line at: index) ~= Character space ] ifNone: [ ^ nil ].
	digits := $0 to: $9.
	(digits includes: firstDigit) ifFalse: [ ^ nil ].
	markerIndex := (numberIndex + 1 to: (numberIndex + 9 min: line size - 2)) detect: [ :index | (digits includes: (marker := line at: index)) not ] ifNone: [ ^ nil ].
	(#($. $)) includes: marker) ifFalse: [ ^ nil ].
	(line at: markerIndex + 1) = Character space ifFalse: [ ^ nil ].
	contentIndex := (markerIndex + 2 to: (markerIndex + 5 min: line size)) detect: [ :index | (line at: index) ~= Character space ] ifNone: [ ^ nil ].
	^ self number: (line copyFrom: numberIndex to: markerIndex - 1) asNumber marker: marker indentationLevel: contentIndex - 1
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockNumberedListItem: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> initializeWithNumber: initialNumber marker: initialMarker indentationLevel: initialIndentationLevel [

	self initialize.
	number := initialNumber.
	marker := initialMarker.
	indentationLevel := initialIndentationLevel.
	sequenceBlock := GeminiTextBlockSequence new.
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> isNumberedListItemBlock [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> lineWithoutStartMarker: line [

	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> markerString [

	^ number asString , (String with: marker)
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> matchLine: line [

	1 to: (line size min: indentationLevel) do: [ :index |
		(line at: index) = Character space ifFalse: [ ^ nil ] ].
	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> number [

	^ number
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Not categorized' }
GeminiTextBlockNumberedListItem >> textElement [

	self shouldNotImplement
]
