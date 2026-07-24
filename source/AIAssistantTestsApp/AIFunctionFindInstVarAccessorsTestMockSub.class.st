Class {
	#name : 'AIFunctionFindInstVarAccessorsTestMockSub',
	#superclass : 'AIFunctionFindInstVarAccessorsTestMockBase',
	#instVars : [
		'myVarOnSubClass'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Accessing' }
AIFunctionFindInstVarAccessorsTestMockSub >> subMethod [
	myVar := 1.
	^ myVar
]

{ #category : 'Accessing' }
AIFunctionFindInstVarAccessorsTestMockSub >> unrelatedMethod [
	^ 42
]
