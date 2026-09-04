Class {
	#name : 'AIChatTextElementLink',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'element',
		'destination',
		'isPointedTo'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextElementLink class >> element: element destination: destination [

	^ self basicNew initializeWithElement: element destination: destination
]

{ #category : 'Comparing' }
AIChatTextElementLink >> = object [

	^ self class = object class and: [ self element = object element and: [ self destination = object destination ] ]
]

{ #category : 'Accessing' }
AIChatTextElementLink >> destination [

	^ destination
]

{ #category : 'Accessing' }
AIChatTextElementLink >> element [

	^ element
]

{ #category : 'Initialization' }
AIChatTextElementLink >> initializeWithElement: initialElement destination: initialDestination [

	self initialize.
	element := initialElement.
	destination := initialDestination.
	isPointedTo := false.
]

{ #category : 'Testing' }
AIChatTextElementLink >> isPointedTo [

	^ isPointedTo
]
