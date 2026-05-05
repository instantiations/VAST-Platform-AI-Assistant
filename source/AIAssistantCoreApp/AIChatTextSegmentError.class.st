Class {
	#name : 'AIChatTextSegmentError',
	#superclass : 'AIAbstractChatTextSegment',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentError class >> fromError: error inChat: chat [

	| sequence sstError |

	sequence := AIChatTextBlockSequence new.
	sequence
		addBlock: (
			AIChatTextBlockText text: (AIChatTextElementString string: 'ERROR: ' , error description));
		addBlock: (
			AIChatTextBlockText text: (
				AIChatTextElementAction
					element: (AIChatTextElementString string: 'Retry')
					block: [error retryInChat: chat])).

	((error error arguments size >= 2) and: [(sstError := error error arguments second) isSstError])
		ifTrue: [
			sequence addBlock: (
				AIChatTextBlockText text: (
					AIChatTextElementAction
						element: (AIChatTextElementString string: 'Show More')
						block: [sstError errorObject contents asString inspect]))].

	^self basicNew initializeWithTextBlocks: { sequence }
]
