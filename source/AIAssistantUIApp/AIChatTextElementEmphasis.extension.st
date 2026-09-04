Extension {
	#name : 'AIChatTextElementEmphasis'
}

{ #category : 'Drawing' }
AIChatTextElementEmphasis >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementEmphasis: self dc: dc
]

{ #category : 'Drawing' }
AIChatTextElementEmphasis >> resetLayout [

	self element resetLayout
]

{ #category : 'Writing' }
AIChatTextElementEmphasis >> writeFormattedOn: stream [

	| delimiterString |

	delimiterString := isStrong ifTrue: [ '**' ] ifFalse: [ '*' ].
	stream nextPutAll: delimiterString.
	element writeFormattedOn: stream.
	stream nextPutAll: delimiterString.
]
