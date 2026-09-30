Class {
	#name : 'AIChatGeneratedContentPartFunctionCall',
	#superclass : 'AIAbstractChatGeneratedContentPart',
	#instVars : [
		'id',
		'name',
		'arguments',
		'thoughtSignature'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall class >> id: id name: functionName arguments: arguments thoughtSignature: thoughtSignature [

	^ self basicNew initializeWithID: id name: functionName arguments: (arguments ifNotNil: [ arguments asFunctionCallArguments ]) thoughtSignature: thoughtSignature; yourself
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> arguments [

	^ arguments
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> displayString [

	^String streamContents: [:str |
		str
			nextPutAll: name;
			space;
			nextPut: $(;
			nextPutAll: arguments displayString;
			nextPut: $)]
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> id [

	^ id
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> initializeWithID: initialID name: initialName arguments: initialArguments thoughtSignature: initialThoughtSignature [

	self initialize.
	id := initialID.
	name := initialName.
	arguments := initialArguments.
	thoughtSignature := initialThoughtSignature.
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> isFunctionCall [

	^ true
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> name [

	^ name
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> thoughtSignature [

	^ thoughtSignature
]
