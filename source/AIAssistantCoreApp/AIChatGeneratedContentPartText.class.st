Class {
	#name : 'AIChatGeneratedContentPartText',
	#superclass : 'AIAbstractChatGeneratedContentPart',
	#instVars : [
		'string',
		'thought',
		'thoughtSignature'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText class >> string: string [

	^ self string: string thought: nil thoughtSignature: nil
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText class >> string: string thought: isThought thoughtSignature: thoughtSignature [

	^ self basicNew initializeWithString: string thought: isThought thoughtSignature: thoughtSignature; yourself
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> initializeWithString: initialString thought: initialThought thoughtSignature: initialThoughtSignature [

	self initialize.
	string := initialString.
	thought := initialThought.
	thoughtSignature := initialThoughtSignature.
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> isText [

	^ true
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> isThought [

	^ thought ifNil: [ false ] ifNotNil: [ thought ]
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> json [

	| jsonObject |

	jsonObject := EsOrderedDictionary with: self class type -> self jsonValue.
	self isThought ifNotNil: [ :value |
		jsonObject at: 'thought' put: value ].
	self thoughtSignature ifNotNil: [ :value |
		jsonObject at: 'thoughtSignature' put: value ].
	^ jsonObject
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> jsonValue [

	^ string
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> string [

	^ string
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> thought [

	^ thought
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartText >> thoughtSignature [

	^ thoughtSignature
]
