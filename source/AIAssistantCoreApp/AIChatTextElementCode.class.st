Class {
	#name : 'AIChatTextElementCode',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'codeTextString',
		'isPointedTo'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextElementCode class >> code: code [

	^ self basicNew initializeWithCode: code
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> = object [

	^ self class = object class and: [ self code = object code ]
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> code [

	^ codeTextString string
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> codeTextString [

	^ codeTextString
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> initializeWithCode: initialCode [

	self initialize.
	codeTextString := AIChatTextString string: initialCode.
	isPointedTo := false.
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> isCodeElement [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> isPointedTo [

	^ isPointedTo
]
