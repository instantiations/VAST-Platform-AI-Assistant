Class {
	#name : 'AIJSONMockUnprintableObject',
	#superclass : 'Object',
	#instVars : [
		'id'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'accessing' }
AIJSONMockUnprintableObject >> id [
	^ id
]

{ #category : 'accessing' }
AIJSONMockUnprintableObject >> id: anObject [
	id := anObject
]

{ #category : 'printing' }
AIJSONMockUnprintableObject >> printOn: aStream [
	Error signal: 'Simulated printOn: failure'
]
