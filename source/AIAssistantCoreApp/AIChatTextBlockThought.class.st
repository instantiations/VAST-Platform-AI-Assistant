Class {
	#name : 'AIChatTextBlockThought',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'sequenceBlock',
		'isPointedTo',
		'isExpanded'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextBlockThought class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> copyStateFrom: anotherThoughtBlock [
	"Copy any state from another block into self"
	isExpanded := anotherThoughtBlock isExpanded.
	isPointedTo := anotherThoughtBlock isPointedTo.
	self sequenceBlock copyStateFrom: anotherThoughtBlock sequenceBlock.
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> initialize [

	super initialize.
	sequenceBlock := AIChatTextBlockSequence new.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> isExpanded [

	^ isExpanded
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> isThoughtBlock [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> lastTopicLine [

	^ sequenceBlock lastTopicLine
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> textElement [

	self shouldNotImplement
]

{ #category : 'Not categorized' }
AIChatTextBlockThought >> toggleIsExpanded [

	isExpanded := isExpanded not
]
