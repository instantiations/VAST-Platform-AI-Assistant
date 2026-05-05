Class {
	#name : 'AIChatTextElementEmphasis',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'isStrong',
		'element'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextElementEmphasis class >> isStrong: isStrong element: element [

	^ self basicNew initializeWithIsStrong: isStrong element: element
]

{ #category : 'Not categorized' }
AIChatTextElementEmphasis >> = object [

	^ self class = object class and: [ self isStrong = object isStrong and: [ self element = object element ] ]
]

{ #category : 'Not categorized' }
AIChatTextElementEmphasis >> element [

	^ element
]

{ #category : 'Not categorized' }
AIChatTextElementEmphasis >> initializeWithIsStrong: initialIsStrong element: initialElement [

	self initialize.
	isStrong := initialIsStrong.
	element := initialElement.
]

{ #category : 'Not categorized' }
AIChatTextElementEmphasis >> isEmphasisElement [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextElementEmphasis >> isStrong [

	^ isStrong
]
