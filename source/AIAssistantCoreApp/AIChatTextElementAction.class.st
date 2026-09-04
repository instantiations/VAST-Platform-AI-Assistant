Class {
	#name : 'AIChatTextElementAction',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'element',
		'isPointedTo',
		'actionBlock'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextElementAction class >> element: element block: block [

	^ self basicNew initializeWithElement: element  block: block
]

{ #category : 'Comparing' }
AIChatTextElementAction >> = object [

	^ self class = object class and: [ self element = object element ]
]

{ #category : 'Accessing' }
AIChatTextElementAction >> element [

	^ element
]

{ #category : 'Initialization' }
AIChatTextElementAction >> initializeWithElement: anElement block: block [

	element :=anElement.
	actionBlock := block.
	isPointedTo := false.
]

{ #category : 'Testing' }
AIChatTextElementAction >> isPointedTo [

	^ isPointedTo
]
