Class {
	#name : 'AIChatTextBlockSequence',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'blocks',
		'lastTopicLine'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextBlockSequence class >> fromString: string [

	| previousLines encounteredCodeStart lastTopicLine sequenceBlock blocks |

	previousLines := OrderedCollection new.
	encounteredCodeStart := false.
	lastTopicLine := nil.
	sequenceBlock := self new.
	blocks := OrderedCollection with: sequenceBlock.
	string linesDo: [ :stringLine |
		| line matchedBlocksCount matchedLine |
		line := stringLine.
		matchedBlocksCount := 1.
		[ matchedBlocksCount < blocks size and: [ (matchedLine := (blocks at: matchedBlocksCount + 1) matchLine: line) notNil ] ] whileTrue: [
			matchedBlocksCount := matchedBlocksCount + 1.
			line := matchedLine ].
		matchedBlocksCount = blocks size ifFalse: [
			previousLines ifNotEmpty: [
				blocks last addBlock: (AIChatTextBlockText fromString: (String crlf join: previousLines)) ].
			previousLines := OrderedCollection new.
			blocks size - matchedBlocksCount timesRepeat: [
				blocks removeLast ] ].
		encounteredCodeStart ifTrue: [
			(line beginsWithSubCollection: '```') ifTrue: [
				blocks last addBlock: (AIChatTextBlockCode code: (String crlf join: previousLines allButFirst)).
				previousLines := OrderedCollection new.
				encounteredCodeStart := false
			] ifFalse: [
				previousLines add: line ]
		] ifFalse: [
			| startedBlock isCodeStart isHeading |
			((stringLine beginsWithSubCollection: '**') and: [ stringLine endsWithSubCollection: '**' ]) ifTrue: [
				lastTopicLine := stringLine ].
			[ { AIChatTextBlockQuote. AIChatTextBlockListItem. AIChatTextBlockNumberedListItem }
				anySatisfy: [ :blockKind | (startedBlock := blockKind startingAtLine: line) notNil ] ] whileTrue: [
					previousLines ifNotEmpty: [
						blocks last addBlock: (AIChatTextBlockText fromString: (String crlf join: previousLines)) ].
					previousLines := OrderedCollection new.
					blocks last addBlock: startedBlock.
					blocks add: startedBlock.
					line := startedBlock lineWithoutStartMarker: line ].
			isCodeStart := line beginsWithSubCollection: '```'.
			isHeading := line beginsWithSubCollection: '#'.
			isCodeStart | isHeading ifTrue: [
				previousLines ifNotEmpty: [
					blocks last addBlock: (AIChatTextBlockText fromString: (String crlf join: previousLines)) ].
				isCodeStart ifTrue: [
					previousLines := OrderedCollection with: line.
					encounteredCodeStart := true ].
				isHeading ifTrue: [
					blocks last addBlock: (AIChatTextBlockHeading fromLine: line).
					previousLines := OrderedCollection new ].
			] ifFalse: [
				(line notEmpty or: [ previousLines isEmpty or: [ previousLines last notEmpty ] ]) ifTrue: [
					previousLines add: line ] ] ] ].
	previousLines ifNotEmpty: [
		blocks last addBlock: (AIChatTextBlockText fromString: (String crlf join: previousLines)) ].
	sequenceBlock lastTopicLine: lastTopicLine.
	^ sequenceBlock
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> = object [

	^ self class = object class and: [ self blocks = object blocks ]
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> addBlock: block [

	blocks add: block.
	block isSequenceBlock ifTrue: [
		block lastTopicLine ifNotNil: [ :newLastTopicLine |
			self lastTopicLine: newLastTopicLine ] ]
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> blocks [

	^ blocks
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> copyStateFrom: otherSequenceBlock [

	otherSequenceBlock blocks doWithIndex: [ :otherTextBlock :index |
		(blocks at: index) copyStateFrom: otherTextBlock ]
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> initialize [

	super initialize.
	blocks := OrderedCollection new.
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> isSequenceBlock [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> lastTopicLine [

	^ lastTopicLine
]

{ #category : 'Not categorized' }
AIChatTextBlockSequence >> lastTopicLine: newLastTopicLine [

	lastTopicLine := newLastTopicLine
]
