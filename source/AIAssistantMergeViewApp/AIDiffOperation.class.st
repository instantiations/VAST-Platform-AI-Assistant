Class {
	#name : 'AIDiffOperation',
	#superclass : 'Object',
	#instVars : [
		'operation',
		'text'
	],
	#category : 'AIAssistantMergeViewApp'
}

{ #category : 'Instance Creation' }
AIDiffOperation class >> operation: aSymbol text: aString [
	^self new operation: aSymbol text: aString
]

{ #category : 'Testing' }
AIDiffOperation >> isDelete [
	^operation == #delete
]

{ #category : 'Testing' }
AIDiffOperation >> isEqual [
	^operation == #equal
]

{ #category : 'Testing' }
AIDiffOperation >> isInsert [
	^operation == #insert
]

{ #category : 'Accessing' }
AIDiffOperation >> operation [
	^operation
]

{ #category : 'Initialization' }
AIDiffOperation >> operation: aSymbol text: aString [
	operation := aSymbol.
	text := aString
]

{ #category : 'Printing' }
AIDiffOperation >> printOn: aStream [
	aStream 
		nextPutAll: self class name;
		nextPut: $(;
		print: operation;
		nextPutAll: ', ';
		print: text;
		nextPut: $)
]

{ #category : 'Accessing' }
AIDiffOperation >> text [
	^text
]
