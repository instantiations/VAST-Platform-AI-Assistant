Class {
	#name : 'AIAbstractFunctionCallArguments',
	#superclass : 'Object',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Converting' }
AIAbstractFunctionCallArguments >> asFunctionCallArguments [

	^ self
]

{ #category : 'Displaying' }
AIAbstractFunctionCallArguments >> displayString [

	^ String streamContents: [ :str |
		self jsonObject associations do: [:assoc | | argumentString |
				str 
					nextPutAll: assoc key;
					nextPutAll: '->'.
				argumentString := assoc value asString.
				argumentString size > 20 ifTrue: [argumentString := argumentString , '...'].
				str nextPutAll: argumentString]
			separatedBy: [str nextPut: $,] ]
]

{ #category : 'Accessing' }
AIAbstractFunctionCallArguments >> jsonObject [

	self subclassResponsibility
]
