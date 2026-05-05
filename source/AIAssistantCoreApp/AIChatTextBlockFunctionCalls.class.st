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

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls class >> new [

	^ self basicNew initialize
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> addFunctionCall: functionCallContentPart [

	functionCalls add: functionCallContentPart
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> copyStateFrom: anotherFunctionBlock [
	"Copy any state from another block into self"
	isExpanded := anotherFunctionBlock isExpanded.
	isPointedTo := anotherFunctionBlock isPointedTo.
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> functionCalls [

	^ functionCalls
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> initialize [

	super initialize.
	functionCalls := OrderedCollection new.
	isPointedTo := false.
	isExpanded := false.
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> isExpanded [

	^ isExpanded
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> isFunctionCallsBlock [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> textElement [

	self shouldNotImplement
]

{ #category : 'Not categorized' }
AIChatTextBlockFunctionCalls >> toggleIsExpanded [

	isExpanded := isExpanded not
]
