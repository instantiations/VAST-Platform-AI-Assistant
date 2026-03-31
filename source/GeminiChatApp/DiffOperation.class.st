Class {
	#name : 'DiffOperation',
	#superclass : 'Object',
	#instVars : [
		'operation',
		'text'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
DiffOperation class >> operation: aSymbol text: aString [
	^self new operation: aSymbol text: aString
]

{ #category : 'Not categorized' }
DiffOperation >> isDelete [
	^operation == #delete
]

{ #category : 'Not categorized' }
DiffOperation >> isEqual [
	^operation == #equal
]

{ #category : 'Not categorized' }
DiffOperation >> isInsert [
	^operation == #insert
]

{ #category : 'Not categorized' }
DiffOperation >> operation [
	^operation
]

{ #category : 'Not categorized' }
DiffOperation >> operation: aSymbol text: aString [
	operation := aSymbol.
	text := aString
]

{ #category : 'Not categorized' }
DiffOperation >> printOn: aStream [
	aStream 
		nextPutAll: self class name;
		nextPut: $(;
		print: operation;
		nextPutAll: ', ';
		print: text;
		nextPut: $)
]

{ #category : 'Not categorized' }
DiffOperation >> text [
	^text
]
