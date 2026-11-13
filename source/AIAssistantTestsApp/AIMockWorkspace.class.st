Class {
	#name : 'AIMockWorkspace',
	#superclass : 'Object',
	#instVars : [
		'label',
		'workspaceContents',
		'workspaceVariables',
		'isWorkspaceClosed'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Initialization' }
AIMockWorkspace >> initialize [

	super initialize.
	label := 'Mock Workspace'.
	workspaceContents := ''.
	workspaceVariables := EsOrderedDictionary new.
	isWorkspaceClosed := false.
]

{ #category : 'Accessing' }
AIMockWorkspace >> isWorkspaceClosed [

	^ isWorkspaceClosed
]

{ #category : 'Accessing' }
AIMockWorkspace >> isWorkspaceClosed: aBoolean [

	isWorkspaceClosed := aBoolean
]

{ #category : 'Accessing' }
AIMockWorkspace >> label [

	^ label
]

{ #category : 'Accessing' }
AIMockWorkspace >> label: aString [

	label := aString
]

{ #category : 'Accessing' }
AIMockWorkspace >> shell [
	"Answer nil since mock workspaces do not have a UI shell widget."

	^ nil
]

{ #category : 'Accessing' }
AIMockWorkspace >> workspaceContents [

	^ workspaceContents
]

{ #category : 'Accessing' }
AIMockWorkspace >> workspaceContents: aString [

	workspaceContents := aString
]

{ #category : 'Accessing' }
AIMockWorkspace >> workspaceVariables [

	^ workspaceVariables
]

{ #category : 'Accessing' }
AIMockWorkspace >> workspaceVariables: aDictionary [

	workspaceVariables := aDictionary
]
