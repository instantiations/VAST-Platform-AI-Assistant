Class {
	#name : 'AIChatTextElementCode',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'codeTextString',
		'isPointedTo'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextElementCode class >> code: code [

	^ self basicNew initializeWithCode: code
]

{ #category : 'Comparing' }
AIChatTextElementCode >> = object [

	^ self class = object class and: [ self code = object code ]
]

{ #category : 'Accessing' }
AIChatTextElementCode >> code [

	^ codeTextString string
]

{ #category : 'Accessing' }
AIChatTextElementCode >> codeTextString [

	^ codeTextString
]

{ #category : 'Initialization' }
AIChatTextElementCode >> initializeWithCode: initialCode [

	self initialize.
	codeTextString := AIChatTextString string: initialCode.
	isPointedTo := false.
]

{ #category : 'Testing' }
AIChatTextElementCode >> isCodeElement [

	^ true
]

{ #category : 'Testing' }
AIChatTextElementCode >> isPointedTo [

	^ isPointedTo
]
