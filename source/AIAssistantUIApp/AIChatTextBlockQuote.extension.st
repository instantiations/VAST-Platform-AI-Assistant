Extension {
	#name : 'AIChatTextBlockQuote'
}

{ #category : 'Drawing' }
AIChatTextBlockQuote >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockQuote: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextBlockQuote >> resetLayout [

	self sequenceBlock resetLayout
]

{ #category : 'Writing' }
AIChatTextBlockQuote >> writeFormattedOn: stream [

	| content |

	content := String streamContents: [ :contentStream | sequenceBlock writeFormattedOn: contentStream ].
	(content ifEmpty: [ CldtConstants::LineDelimiter ]) linesDo: [ :line |
		stream
			nextPutAll: '> ';
			nextPutAll: line;
			newLine ]
]
