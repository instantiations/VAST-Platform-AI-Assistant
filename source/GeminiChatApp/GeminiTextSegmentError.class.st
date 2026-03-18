Class {
	#name : 'GeminiTextSegmentError',
	#superclass : 'GeminiAbstractTextSegment',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextSegmentError class >> fromError: error inChat: aGeminiChat [

	| sequence sstError |

	sequence := GeminiTextBlockSequence new.
	sequence
		addBlock: (
			GeminiTextBlockText text: (GeminiTextElementString string: 'ERROR: ' , error description));
		addBlock: (
			GeminiTextBlockText text: (
				GeminiTextElementAction
					element: (GeminiTextElementString string: 'Retry')
					block: [error retryInChat: aGeminiChat])).

	((error error arguments size >= 2) and: [(sstError := error error arguments second) isSstError])
		ifTrue: [
			sequence addBlock: (
				GeminiTextBlockText text: (
					GeminiTextElementAction
						element: (GeminiTextElementString string: 'Show More')
						block: [sstError errorObject contents asString inspect]))].

	^self basicNew initializeWithTextBlocks: { sequence }
]

{ #category : 'Not categorized' }
GeminiTextSegmentError >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextSegmentError: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextSegmentError >> textColor [

	^ Color red
]
