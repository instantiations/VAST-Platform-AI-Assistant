Extension {
	#name : 'AIChatUserMessage'
}

{ #category : 'Not categorized' }
AIChatUserMessage >> storeOn: stream [

	stream nextPut: $(.
	self class storeOn: stream.
	stream nextPutAll: ' message: '.
	message storeOn: stream.
	stream nextPutAll: ' generatedContents: '.
	generatedContents storeOn: stream.
	stream nextPutAll: ' codeChanges: '.
	codeChanges storeOn: stream.
	stream nextPut: $).
]

{ #category : 'Not categorized' }
AIChatUserMessage >> writeFormattedOn: stream [

	| userQuoteTextBlock |

	userQuoteTextBlock := AIChatTextBlockQuote new.
	self userText textBlocks do: [ :textBlock |
		userQuoteTextBlock addBlock: textBlock ].
	userQuoteTextBlock writeFormattedOn: stream.
	stream newLine.
	
	(self modelText textBlocks reject: [ :block | block isThoughtBlock or: [ block isFunctionCallsBlock ] ])
		do: [ :block | block writeFormattedOn: stream ]
		separatedBy: [ stream newLine ]
]
