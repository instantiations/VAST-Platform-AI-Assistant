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

	^ self basicNew initializeWithID: id name: functionName arguments: arguments thoughtSignature: thoughtSignature; yourself
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
			nextPut: $(.
		arguments associations do: [:assoc | | argumentString |
				str 
					nextPutAll: assoc key;
					nextPutAll: '->'.
				argumentString := assoc value asString.
				argumentString size > 20 ifTrue: [argumentString := argumentString , '...'].
				str nextPutAll: argumentString]
			separatedBy: [str nextPut: $,].
		str nextPut: $)]
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
AIChatGeneratedContentPartFunctionCall >> json [

	| jsonObject |

	jsonObject := EsOrderedDictionary with: self class type -> self jsonValue.
	self thoughtSignature ifNotNil: [ :value |
		jsonObject at: 'thoughtSignature' put: value ].
	^ jsonObject
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> jsonValue [

	| jsonValue |

	jsonValue := EsOrderedDictionary new.
	id ifNotNil: [
		jsonValue at: 'id' put: id ].
	jsonValue at: 'name' put: name.
	arguments ifNotNil: [
		jsonValue at: 'args' put: arguments ].
	^ jsonValue
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> name [

	^ name
]

{ #category : 'Not categorized' }
AIChatGeneratedContentPartFunctionCall >> thoughtSignature [

	^ thoughtSignature
]
