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

{ #category : 'Instantiation' }
AIChatTextBlockThought class >> new [

	^ self basicNew initialize
]

{ #category : 'Accessing' }
AIChatTextBlockThought >> addBlock: block [

	sequenceBlock addBlock: block
]

{ #category : 'Copying' }
AIChatTextBlockThought >> copyStateFrom: anotherThoughtBlock [
	"Copy any state from another block into self"
	isExpanded := anotherThoughtBlock isExpanded.
	isPointedTo := anotherThoughtBlock isPointedTo.
	self sequenceBlock copyStateFrom: anotherThoughtBlock sequenceBlock.
]

{ #category : 'Initialization' }
AIChatTextBlockThought >> initialize [

	super initialize.
	sequenceBlock := AIChatTextBlockSequence new.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Testing' }
AIChatTextBlockThought >> isExpanded [

	^ isExpanded
]

{ #category : 'Testing' }
AIChatTextBlockThought >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Testing' }
AIChatTextBlockThought >> isThoughtBlock [

	^ true
]

{ #category : 'Accessing' }
AIChatTextBlockThought >> lastTopicLine [

	^ sequenceBlock lastTopicLine
]

{ #category : 'Accessing' }
AIChatTextBlockThought >> sequenceBlock [

	^ sequenceBlock
]

{ #category : 'Accessing' }
AIChatTextBlockThought >> textElement [

	self shouldNotImplement
]

{ #category : 'Accessing' }
AIChatTextBlockThought >> toggleIsExpanded [

	isExpanded := isExpanded not
]
