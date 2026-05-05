Class {
	#name : 'AIChatTextElementString',
	#superclass : 'AIAbstractChatTextElement',
	#instVars : [
		'textString'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextElementString class >> new [

	^ self string: ''
]

{ #category : 'Not categorized' }
AIChatTextElementString class >> string: string [

	^ self basicNew initializeWithString: string
]

{ #category : 'Not categorized' }
AIChatTextElementString >> = object [

	^ self class = object class and: [ self string = object string ]
]

{ #category : 'Not categorized' }
AIChatTextElementString >> initializeWithString: initialString [

	self initialize.
	textString := AIChatTextString string: initialString.
]

{ #category : 'Not categorized' }
AIChatTextElementString >> isStringElement [

	^ true
]

{ #category : 'Not categorized' }
AIChatTextElementString >> string [

	^ textString string
]

{ #category : 'Not categorized' }
AIChatTextElementString >> string: newString [

	textString := AIChatTextString string: newString
]

{ #category : 'Not categorized' }
AIChatTextElementString >> textString [

	^ textString
]
