Class {
	#name : 'AIChatTextBlockSequenceTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIChatTextBlockSequenceTest >> assertBlockSequenceFromLines: lines hasBlocks: blocks [

	self assertBlockSequenceFromString: (String lf join: lines) hasBlocks: blocks
]

{ #category : 'Not categorized' }
AIChatTextBlockSequenceTest >> assertBlockSequenceFromString: string hasBlocks: blocks [

	| expectedBlockSequence |

	expectedBlockSequence := AIChatTextBlockSequence new.
	blocks do: [ :block |
		expectedBlockSequence addBlock: block ].
	self assert: (AIChatTextBlockSequence fromString: string) equals: expectedBlockSequence
]

{ #category : 'Not categorized' }
AIChatTextBlockSequenceTest >> testFromString [

	self assertBlockSequenceFromString: 'Some text' hasBlocks: {
		AIChatTextBlockText fromString: 'Some text' }.
	self assertBlockSequenceFromString: '# A Heading' hasBlocks: {
		AIChatTextBlockHeading level: 1 text: (AIChatTextElementSequence fromString: 'A Heading') }.
	self assertBlockSequenceFromString: '## Another Heading' hasBlocks: {
		AIChatTextBlockHeading level: 2 text: (AIChatTextElementSequence fromString: 'Another Heading') }.
	self assertBlockSequenceFromString: '- A list item' hasBlocks: {
		(AIChatTextBlockListItem marker: $- indentationLevel: 2) addBlock: (AIChatTextBlockText fromString: 'A list item'); yourself }.
	self assertBlockSequenceFromString: '1. A numbered list item' hasBlocks: {
		(AIChatTextBlockNumberedListItem number: 1 marker: $. indentationLevel: 4) addBlock: (AIChatTextBlockText fromString: 'A numbered list item'); yourself }.
	self assertBlockSequenceFromString: '2. Another numbered list item' hasBlocks: {
		(AIChatTextBlockNumberedListItem number: 2 marker: $. indentationLevel: 4) addBlock: (AIChatTextBlockText fromString: 'Another numbered list item'); yourself }.
	self assertBlockSequenceFromString: '> A quote' hasBlocks: {
		AIChatTextBlockQuote new addBlock: (AIChatTextBlockText fromString: 'A quote'); yourself }.
	self assertBlockSequenceFromString: '```' , String lf , 'Some code' , String lf , '```' hasBlocks: {
		AIChatTextBlockCode code: 'Some code' }.

	self assertBlockSequenceFromLines: #('1' '' '' '4' '```' '6' '' '' '9' '```') hasBlocks: {
		AIChatTextBlockText text: (AIChatTextElementSequence elements: (OrderedCollection with: (AIChatTextElementString string: '1'))).
		AIChatTextBlockText text: (AIChatTextElementSequence elements: (OrderedCollection with: (AIChatTextElementString string: '4'))).
		AIChatTextBlockCode code: '6' , CldtConstants::LineDelimiter , CldtConstants::LineDelimiter , CldtConstants::LineDelimiter , '9' }.

]
