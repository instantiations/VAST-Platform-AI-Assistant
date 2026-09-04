Extension {
	#name : 'AIChatTextBlockListItem'
}

{ #category : 'Drawing' }
AIChatTextBlockListItem >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockListItem: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextBlockListItem >> resetLayout [

	self sequenceBlock resetLayout
]

{ #category : 'Drawing' }
AIChatTextBlockListItem >> spacingFactorAfter [

	^ 1 / 10
]

{ #category : 'Drawing' }
AIChatTextBlockListItem >> spacingFactorBefore [

	^ 1 / 10
]

{ #category : 'Writing' }
AIChatTextBlockListItem >> writeFormattedOn: stream [

	| content isFirst |

	content := String streamContents: [ :contentStream | sequenceBlock writeFormattedOn: contentStream ].
	isFirst := true.
	content linesDo: [ :line |
		stream
			nextPutAll: (isFirst ifTrue: [ '* ' ] ifFalse: [ '  ' ]);
			nextPutAll: line;
			newLine.
		isFirst := false ]
]
