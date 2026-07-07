Class {
	#name : 'AIChatTextBlockCode',
	#superclass : 'AIAbstractChatTextBlock',
	#instVars : [
		'code',
		'infoString',
		'isPointedTo'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instance Creation' }
AIChatTextBlockCode class >> code: code [

	^ self code: code infoString: nil
]

{ #category : 'Instance Creation' }
AIChatTextBlockCode class >> code: code infoString: infoString [

	^ self basicNew initializeWithCode: code infoString: infoString
]

{ #category : 'Not categorized' }
AIChatTextBlockCode >> = object [

	^ self class = object class and: [ self code = object code ]
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> code [

	^ code
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> infoString [

	^ infoString
]

{ #category : 'Initialization' }
AIChatTextBlockCode >> initializeWithCode: initialCode infoString: initialInfoString [

	self initialize.
	code := initialCode.
	infoString := initialInfoString.
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
