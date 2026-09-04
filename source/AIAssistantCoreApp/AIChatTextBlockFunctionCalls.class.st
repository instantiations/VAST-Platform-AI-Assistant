Class {
	#name : 'AIChatTextBlockFunctionCalls',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'functionCalls',
		'isPointedTo',
		'isExpanded'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextBlockFunctionCalls class >> new [

	^ self basicNew initialize
]

{ #category : 'Accessing' }
AIChatTextBlockFunctionCalls >> addFunctionCall: functionCallContentPart [

	functionCalls add: functionCallContentPart
]

{ #category : 'Copying' }
AIChatTextBlockFunctionCalls >> copyStateFrom: anotherFunctionBlock [
	"Copy any state from another block into self"
	isExpanded := anotherFunctionBlock isExpanded.
	isPointedTo := anotherFunctionBlock isPointedTo.
]

{ #category : 'Accessing' }
AIChatTextBlockFunctionCalls >> functionCalls [

	^ functionCalls
]

{ #category : 'Initialization' }
AIChatTextBlockFunctionCalls >> initialize [

	super initialize.
	functionCalls := OrderedCollection new.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Testing' }
AIChatTextBlockFunctionCalls >> isExpanded [

	^ isExpanded
]

{ #category : 'Testing' }
AIChatTextBlockFunctionCalls >> isFunctionCallsBlock [

	^ true
]

{ #category : 'Testing' }
AIChatTextBlockFunctionCalls >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Accessing' }
AIChatTextBlockFunctionCalls >> textElement [

	self shouldNotImplement
]

{ #category : 'Accessing' }
AIChatTextBlockFunctionCalls >> toggleIsExpanded [

	isExpanded := isExpanded not
]
