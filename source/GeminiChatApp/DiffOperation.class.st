Class {
	#name : 'DiffOperation',
	#superclass : 'Object',
	#instVars : [
		'operation',
		'text'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Instance Creation' }
DiffOperation class >> operation: aSymbol text: aString [
	^self new operation: aSymbol text: aString
]

{ #category : 'Testing' }
DiffOperation >> isDelete [
	^operation == #delete
]

{ #category : 'Testing' }
DiffOperation >> isEqual [
	^operation == #equal
]

{ #category : 'Testing' }
DiffOperation >> isInsert [
	^operation == #insert
]

{ #category : 'Accessing' }
DiffOperation >> operation [
	^operation
]

{ #category : 'Initialization' }
DiffOperation >> operation: aSymbol text: aString [
	operation := aSymbol.
	text := aString
]

{ #category : 'Printing' }
DiffOperation >> printOn: aStream [
	aStream 
		nextPutAll: self class name;
		nextPut: $(;
		print: operation;
		nextPutAll: ', ';
		print: text;
		nextPut: $)
]

{ #category : 'Accessing' }
DiffOperation >> text [
	^text
]
