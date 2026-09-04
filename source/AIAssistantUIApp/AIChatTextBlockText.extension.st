Extension {
	#name : 'AIChatTextBlockText'
}

{ #category : 'Drawing' }
AIChatTextBlockText >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextBlockText: self dc: dc
]

{ #category : 'Writing' }
AIChatTextBlockText >> writeFormattedOn: stream [

	| content digits |

	content := String streamContents: [ :contentStream | text writeFormattedOn: contentStream ].
	digits := $0 to: $9.
	content linesDo: [ :line |
		line ifNotEmpty: [
			| indexToEscape |
			indexToEscape := nil.
			(#($# $>) includes: line first) ifTrue: [
				indexToEscape := 1 ].
			((1 to: (4 min: line size)) detect: [ :index | (line at: index) ~= Character space ] ifNone: [ nil ]) ifNotNil: [ :startIndex |
				((#($* $- $+) includes: (line at: startIndex)) and: [ startIndex < line size and: [ (line at: startIndex + 1) = Character space ] ]) ifTrue: [
					indexToEscape := startIndex ].
				(digits includes: (line at: startIndex)) ifTrue: [
					((startIndex to: (startIndex + 9 min: line size)) detect: [ :index | (digits includes: (line at: index)) not ] ifNone: [ nil ]) ifNotNil: [ :stopIndex |
						(#($. $)) includes: (line at: stopIndex)) ifTrue: [
							indexToEscape := stopIndex ] ] ] ].
			indexToEscape ifNil: [
				stream nextPutAll: line
			] ifNotNil: [
				stream
					nextPutAll: (line copyFrom: 1 to: indexToEscape - 1);
					nextPut: $\;
					nextPutAll: (line copyFrom: indexToEscape to: line size) ] ].
		stream newLine ]
]
