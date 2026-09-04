Class {
	#name : 'AIChatTextBlockText',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'text'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextBlockText class >> fromString: string [

	^ self text: (AIChatTextElementSequence fromString: string)
]

{ #category : 'Instantiation' }
AIChatTextBlockText class >> new [

	^ self text: AIChatTextElementString new
]

{ #category : 'Instantiation' }
AIChatTextBlockText class >> text: text [

	^ self basicNew initializeWithText: text
]

{ #category : 'Comparing' }
AIChatTextBlockText >> = object [

	^ self class = object class and: [ self textElement = object textElement ]
]

{ #category : 'Initialization' }
AIChatTextBlockText >> initializeWithText: initialText [

	self initialize.
	text := initialText.
]

{ #category : 'Testing' }
AIChatTextBlockText >> isTextBlock [

	^ true
]

{ #category : 'Accessing' }
AIChatTextBlockText >> textElement [

	^ text
]
