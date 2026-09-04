Class {
	#name : 'AIChatTextElementString',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'textString'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instantiation' }
AIChatTextElementString class >> new [

	^ self string: ''
]

{ #category : 'Instantiation' }
AIChatTextElementString class >> string: string [

	^ self basicNew initializeWithString: string
]

{ #category : 'Comparing' }
AIChatTextElementString >> = object [

	^ self class = object class and: [ self string = object string ]
]

{ #category : 'Initialization' }
AIChatTextElementString >> initializeWithString: initialString [

	self initialize.
	textString := AIChatTextString string: initialString.
]

{ #category : 'Testing' }
AIChatTextElementString >> isStringElement [

	^ true
]

{ #category : 'Accessing' }
AIChatTextElementString >> string [

	^ textString string
]

{ #category : 'Accessing' }
AIChatTextElementString >> string: newString [

	textString := AIChatTextString string: newString
]

{ #category : 'Accessing' }
AIChatTextElementString >> textString [

	^ textString
]
