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

{ #category : 'Not categorized' }
AIChatTextElementLink class >> element: element destination: destination [

	^ self basicNew initializeWithElement: element destination: destination
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> = object [

	^ self class = object class and: [ self element = object element and: [ self destination = object destination ] ]
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> destination [

	^ destination
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> element [

	^ element
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> initializeWithElement: initialElement destination: initialDestination [

	self initialize.
	element := initialElement.
	destination := initialDestination.
	isPointedTo := false.
]

{ #category : 'Not categorized' }
AIChatTextElementLink >> isPointedTo [

	^ isPointedTo
]
