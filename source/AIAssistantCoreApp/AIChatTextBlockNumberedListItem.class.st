Class {
	#name : 'AIChatTextBlockNumberedListItem',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'number',
		'marker',
		'indentationLevel',
		'sequenceBlock'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextBlockNumberedListItem class >> number: number marker: marker indentationLevel: indentationLevel [

	^ self basicNew initializeWithNumber: number marker: marker indentationLevel: indentationLevel
]

{ #category : 'Instantiation' }
AIChatTextBlockNumberedListItem class >> startingAtLine: line [

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

{ #category : 'Comparing' }
AIChatTextBlockNumberedListItem >> = object [

	^ self class = object class and: [ self number = object number and: [ self sequenceBlock = object sequenceBlock ] ]
]

{ #category : 'Accessing' }
AIChatTextBlockNumberedListItem >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Initialization' }
AIChatTextBlockNumberedListItem >> initializeWithNumber: initialNumber marker: initialMarker indentationLevel: initialIndentationLevel [

	self initialize.
	number := initialNumber.
	marker := initialMarker.
	indentationLevel := initialIndentationLevel.
	sequenceBlock := AIChatTextBlockSequence new.
]

{ #category : 'Testing' }
AIChatTextBlockNumberedListItem >> isNumberedListItemBlock [

	^ true
]

{ #category : 'Parsing' }
AIChatTextBlockNumberedListItem >> lineWithoutStartMarker: line [

	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Accessing' }
AIChatTextBlockNumberedListItem >> markerString [

	^ number asString , (String with: marker)
]

{ #category : 'Parsing' }
AIChatTextBlockNumberedListItem >> matchLine: line [

	1 to: (line size min: indentationLevel) do: [ :index |
		(line at: index) = Character space ifFalse: [ ^ nil ] ].
	^ line copyFrom: indentationLevel + 1 to: line size
]

{ #category : 'Accessing' }
AIChatTextBlockNumberedListItem >> number [

	^ number
]

{ #category : 'Accessing' }
AIChatTextBlockNumberedListItem >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Accessing' }
AIChatTextBlockNumberedListItem >> textElement [

	self shouldNotImplement
]
