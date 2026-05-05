Class {
	#name : 'AIChatTextBlockCode',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'code',
		'isPointedTo'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instance Creation' }
AIChatTextBlockCode class >> code: code [

	^ self basicNew initializeWithCode: code
]

{ #category : 'Not categorized' }
AIChatTextBlockCode >> = object [

	^ self class = object class and: [ self code = object code ]
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> code [

	^ code
]

{ #category : 'Initialization' }
AIChatTextBlockCode >> initializeWithCode: initialCode [

	self initialize.
	code := initialCode.
	isPointedTo := false.
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> isCodeBlock [

	^ true
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> textElement [

	^ AIChatTextElementString string: code
]
