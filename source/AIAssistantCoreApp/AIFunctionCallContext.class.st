Class {
	#name : 'AIFunctionCallContext',
	#superclass : 'Object',
	#instVars : [
		'model',
		'filePaths',
		'codeChanges',
		'objectRegistry',
		'workspaceRegistry'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instance Creation' }
AIFunctionCallContext class >> model: model filePaths: filePaths codeChanges: codeChanges objectRegistry: objectRegistry workspaceRegistry: workspaceRegistry [

	^ self basicNew initializeWith: model filePaths: filePaths codeChanges: codeChanges objectRegistry: objectRegistry workspaceRegistry: workspaceRegistry
]

{ #category : 'Accessing' }
AIFunctionCallContext >> addRefactoryChange: change [

	codeChanges add: change
]

{ #category : 'Accessing' }
AIFunctionCallContext >> codeChanges [

	^codeChanges
	
]

{ #category : 'Accessing' }
AIFunctionCallContext >> filePaths [

	^ filePaths
]

{ #category : 'Initialization' }
AIFunctionCallContext >> initializeWith: initialModel filePaths: initialFilePaths codeChanges: initialCodeChanges objectRegistry: initialObjectRegistry workspaceRegistry: initialWorkspaceRegistry [

	self initialize.
	model := initialModel.
	filePaths := initialFilePaths.
	codeChanges := initialCodeChanges.
	objectRegistry := initialObjectRegistry.
	workspaceRegistry := initialWorkspaceRegistry.
]

{ #category : 'Accessing' }
AIFunctionCallContext >> model [
	^model
]

{ #category : 'Accessing' }
AIFunctionCallContext >> objectRegistry [

	^ objectRegistry
]

{ #category : 'Accessing' }
AIFunctionCallContext >> workspaceRegistry [

	^ workspaceRegistry
]
