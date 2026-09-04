Class {
	#name : 'AIChatTextElementEmphasis',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'isStrong',
		'element'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextElementEmphasis class >> isStrong: isStrong element: element [

	^ self basicNew initializeWithIsStrong: isStrong element: element
]

{ #category : 'Comparing' }
AIChatTextElementEmphasis >> = object [

	^ self class = object class and: [ self isStrong = object isStrong and: [ self element = object element ] ]
]

{ #category : 'Accessing' }
AIChatTextElementEmphasis >> element [

	^ element
]

{ #category : 'Initialization' }
AIChatTextElementEmphasis >> initializeWithIsStrong: initialIsStrong element: initialElement [

	self initialize.
	isStrong := initialIsStrong.
	element := initialElement.
]

{ #category : 'Testing' }
AIChatTextElementEmphasis >> isEmphasisElement [

	^ true
]

{ #category : 'Testing' }
AIChatTextElementEmphasis >> isStrong [

	^ isStrong
]
