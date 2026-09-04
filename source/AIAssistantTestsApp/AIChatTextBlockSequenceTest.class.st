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
AIChatTextBlockSequenceTest >> assertBlockSequenceFromLines: lines hasTextBlockWithString: textElementString [

	self assertBlockSequenceFromString: (String lf join: lines) hasTextBlockWithString: textElementString
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
AIChatTextBlockSequenceTest >> assertBlockSequenceFromString: string hasTextBlockWithString: textElementString [

	self assertBlockSequenceFromString: string hasBlocks: {
		AIChatTextBlockText text: (AIChatTextElementSequence elements:
			(OrderedCollection with: (AIChatTextElementString string: textElementString))) }
]

{ #category : 'Not categorized' }
AIChatTextBlockSequenceTest >> assertFormattedStringIsEquivalentForBlockSequenceFromLines: lines [

	self assertFormattedStringIsEquivalentForBlockSequenceFromString: (String lf join: lines)
]

{ #category : 'Not categorized' }
AIChatTextBlockSequenceTest >> assertFormattedStringIsEquivalentForBlockSequenceFromString: string [

	| blockSequence1 formattedString blockSequence2 |

	blockSequence1 := AIChatTextBlockSequence fromString: string.
	formattedString := String streamContents: [ :stream | blockSequence1 writeFormattedOn: stream ].
	blockSequence2 := AIChatTextBlockSequence fromString: formattedString.

	self assert: blockSequence2 equals: blockSequence1
]

{ #category : 'Not categorized' }
AIChatTextBlockSequenceTest >> testFromString [

	self assertBlockSequenceFromString: 'Some text' hasBlocks: {
		AIChatTextBlockText fromString: 'Some text' }.
	self assertBlockSequenceFromString: '# A Heading' hasBlocks: {
		AIChatTextBlockHeading level: 1 text: (AIChatTextElementSequence fromString: 'A Heading') }.
	self assertBlockSequenceFromString: '## Another Heading' hasBlocks: {
		AIChatTextBlockHeading level: 2 text: (AIChatTextElementSequence fromString: 'Another Heading') }.
	self assertBlockSequenceFromString: '# ``` A Heading with Backticks' hasBlocks: {
		AIChatTextBlockHeading level: 1 text: (AIChatTextElementSequence fromString: '``` A Heading with Backticks') }.
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
	self assertBlockSequenceFromLines: #('```' '\x\*\\' '```') hasBlocks: {
		AIChatTextBlockCode code: '\x\*\\' }.
	self assertBlockSequenceFromLines: #('```' '\```' '```') hasBlocks: {
		AIChatTextBlockCode code: '\```' }.

	self assertBlockSequenceFromString: '\# Not a heading' hasTextBlockWithString: '# Not a heading'.
	self assertBlockSequenceFromString: '\- Not a list item' hasTextBlockWithString: '- Not a list item'.
	self assertBlockSequenceFromString: '\1. Not a numbered list item' hasTextBlockWithString: '\1. Not a numbered list item'.
	self assertBlockSequenceFromString: '1\. Not a numbered list item' hasTextBlockWithString: '1. Not a numbered list item'.
	self assertBlockSequenceFromString: '\> Not a quote' hasTextBlockWithString: '> Not a quote'.
	self assertBlockSequenceFromLines: #('\```' 'Not a code block') hasTextBlockWithString: '```' , CldtConstants::LineDelimiter , 'Not a code block'.
	self assertBlockSequenceFromLines: #('\```' 'Not a code block' '\```') hasTextBlockWithString: '```' , CldtConstants::LineDelimiter , 'Not a code block' , CldtConstants::LineDelimiter , '```'.
]

{ #category : 'Not categorized' }
AIChatTextBlockSequenceTest >> testWriteFormattedOn [

	self assertFormattedStringIsEquivalentForBlockSequenceFromString: 'Some text'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '*Italic*'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '**Bold**'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '`1 + 2`'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '[Text](https://example.com)'.

	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '# A Heading'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '## Another Heading'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '# ``` A Heading with Backticks'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '- A list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '* Another list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '+ Yet another list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '   - An indented list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '1. A numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '2) Another numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '123456789. A numbered list item with the maximum number of digits'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '   123. An indented numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '> A quote'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('```' '1 + 2' '```').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('```' '' '1 + 2' '' '```').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('```smalltalk' 'Transcript show: ''Hello world!''; cr' '```').

	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('```' '```').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('````' '```' '````').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('`````' '```' '````' '```' '`````').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('```' '\```' '```').

	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('* A list item' '  with multiple lines').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('1. A numbered list item' '   with multiple lines').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('2) Another numbered list item' '   with multiple lines').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('123. A numbered list item' '     with multiple digits' '     and multiple lines').

	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('> A quote' '> with multiple' '> ' '> lines').
	
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '#'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '# '.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '-'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '- '.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '1.'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '1. '.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '>'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '> '.

	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '\# Not a heading'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '-Not a list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '\- Not a list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '\* Not a list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '\+ Not a list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '   \- Not an indented list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '1.Not a numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '\1. Not a numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '1\. Not a numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '1\) Not a numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '123\. Not a numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '   123\. Not an indented numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '1234567890. Not a numbered list item'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromString: '\> Not a quote'.
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('\```' 'Not a code block').
	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #('\```' 'Not a code block' '\```').

	self assertFormattedStringIsEquivalentForBlockSequenceFromLines: #(
		'* A list item'
		'  * A nested list item'
		'  * Another nested list item,'
		'    with a code block:'
		'    '
		'    ```'
		'    1 + 2'
		'    ```'
		'  * And one with a nested block quote'
		'    > A nested quote'
		'    > > A deeper nested block quote'
		'    > > # A nested heading'
		'    > * A list item inside the quote'
		'    >   * A nested list item inside the quote').
]
