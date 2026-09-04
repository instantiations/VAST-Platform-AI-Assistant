Class {
	#name : 'AIJSONMockClass',
	#superclass : 'Object',
	#instVars : [
		'var1',
		'var2'
	],
	#classVars : [
		'ZClassVar2',
		'ClassVar1',
		'AClassVar3'
	],
	#pools : [
		'CldtConstants'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'mock' }
AIJSONMockClass class >> mockClassMethod [
	^ 'this is a mock class method'
]

{ #category : 'mock' }
AIJSONMockClass >> mockMethod [
	^ 'this is a mock method'
]
