Class {
	#name : 'AIChatTextBlockText',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'text'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextBlockText class >> fromString: string [

	^ self text: (AIChatTextElementSequence fromString: string)
]

{ #category : 'Not categorized' }
AIChatTextBlockText class >> new [

	^ self text: AIChatTextElementString new
]

{ #category : 'Not categorized' }
AIChatTextBlockText class >> text: text [

	^ self basicNew initializeWithText: text
]

{ #category : 'Not categorized' }
AIChatTextBlockText >> = object [

	^ self class = object class and: [ self textElement = object textElement ]
]

{ #category : 'Not categorized' }
AIChatTextBlockText >> initializeWithText: initialText [

	self initialize.
	text := initialText.
]

{ #category : 'Not categorized' }
AIChatTextBlockText >> isTextBlock [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextBlockText >> textElement [

	^ text
]
