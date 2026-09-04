Extension {
	#name : 'AIChatTextBlockNumberedListItem'
}

{ #category : 'Drawing' }
AIChatTextBlockNumberedListItem >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockNumberedListItem: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextBlockNumberedListItem >> resetLayout [

	self sequenceBlock resetLayout
]

{ #category : 'Drawing' }
AIChatTextBlockNumberedListItem >> spacingFactorAfter [

	^ 1 / 10
]

{ #category : 'Drawing' }
AIChatTextBlockNumberedListItem >> spacingFactorBefore [

	^ 1 / 10
]

{ #category : 'Writing' }
AIChatTextBlockNumberedListItem >> writeFormattedOn: stream [

	| content markerString indentationString isFirst |

	content := String streamContents: [ :contentStream | sequenceBlock writeFormattedOn: contentStream ].
	markerString := number asString , '. '.
	indentationString := String new: markerString size withAll: Character space.
	isFirst := true.
	content linesDo: [ :line |
		stream
			nextPutAll: (isFirst ifTrue: [ markerString ] ifFalse: [ indentationString ]);
			nextPutAll: line;
			newLine.
		isFirst := false ]
]
