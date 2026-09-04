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

{ #category : 'Instantiation' }
AIChatTextBlockCode class >> code: code [

	^ self code: code infoString: nil
]

{ #category : 'Instantiation' }
AIChatTextBlockCode class >> code: code infoString: infoString [

	^ self basicNew initializeWithCode: code infoString: infoString
]

{ #category : 'Comparing' }
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

{ #category : 'Testing' }
AIChatTextBlockCode >> isCodeBlock [

	^ true
]

{ #category : 'Testing' }
AIChatTextBlockCode >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> textElement [

	^ AIChatTextElementString string: code
]
