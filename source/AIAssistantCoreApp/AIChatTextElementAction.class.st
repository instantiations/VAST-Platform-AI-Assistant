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

{ #category : 'Not categorized' }
AIChatTextElementAction class >> element: element block: block [

	^ self basicNew initializeWithElement: element  block: block
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> = object [

	^ self class = object class and: [ self element = object element ]
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> element [

	^ element
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> initializeWithElement: anElement block: block [

	element :=anElement.
	actionBlock := block.
	isPointedTo := false.
]

{ #category : 'Not categorized' }
AIChatTextElementAction >> isPointedTo [

	^ isPointedTo
]
