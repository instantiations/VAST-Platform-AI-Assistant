Class {
	#name : 'AIWorkspaceRegistry',
	#superclass : 'Object',
	#instVars : [
		'chat',
		'workspaces',
		'nextWorkspaceHandle'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Instance Creation' }
AIWorkspaceRegistry class >> forChat: aChat [

	^ self forChat: aChat initialNextWorkspaceHandle: 1
]

{ #category : 'Instance Creation' }
AIWorkspaceRegistry class >> forChat: aChat initialNextWorkspaceHandle: initialNextWorkspaceHandle [
	"Answer a new instance of the receiver for aChat initialized to assign workspace handles starting from initialNextWorkspaceHandle."

	^ self basicNew initializeWithChat: aChat nextWorkspaceHandle: initialNextWorkspaceHandle
]

{ #category : 'Testing' }
AIWorkspaceRegistry class >> isWorkspaceValid: aWorkspace [
	"Answer whether aWorkspace is an active, open workspace implementing the workspace protocol."

	^ [
		aWorkspace notNil
			and: [ (aWorkspace respondsTo: #workspaceVariables)
			and: [ (aWorkspace respondsTo: #isWorkspaceClosed)
			and: [ aWorkspace isWorkspaceClosed not ] ] ]
	] on: Error do: [ :ex | ex return: false ]
]

{ #category : 'Accessing' }
AIWorkspaceRegistry >> activeWorkspaces [

	^ self workspaces select: [ :workspace | self class isWorkspaceValid: workspace ]
]

{ #category : 'Actions' }
AIWorkspaceRegistry >> add: aWorkspace [

	(self includes: aWorkspace) ifFalse: [
		workspaces at: nextWorkspaceHandle put: aWorkspace.
		nextWorkspaceHandle := nextWorkspaceHandle + 1.
		self registerDestroyCallbackFor: aWorkspace.
		self notifyWorkspacesChanged ]
]

{ #category : 'Accessing' }
AIWorkspaceRegistry >> at: aHandle ifAbsent: aBlock [

	^ self workspaces at: aHandle ifAbsent: aBlock
]

{ #category : 'Testing' }
AIWorkspaceRegistry >> hasActiveWorkspaces [

	^ self workspaces anySatisfy: [ :workspace | self class isWorkspaceValid: workspace ]
]

{ #category : 'Testing' }
AIWorkspaceRegistry >> includes: aWorkspace [

	^ self workspaces includes: aWorkspace
]

{ #category : 'Initialization' }
AIWorkspaceRegistry >> initializeWithChat: initialChat nextWorkspaceHandle: initialNextWorkspaceHandle [

	self initialize.
	chat := initialChat.
	workspaces := EsOrderedDictionary new.
	nextWorkspaceHandle := initialNextWorkspaceHandle
]

{ #category : 'Testing' }
AIWorkspaceRegistry >> isEmpty [

	^ self workspaces isEmpty
]

{ #category : 'Enumerating' }
AIWorkspaceRegistry >> keysAndValuesDo: aBlock [

	self workspaces keysAndValuesDo: aBlock
]

{ #category : 'Accessing' }
AIWorkspaceRegistry >> nextWorkspaceHandle [
	"Answer the next handle that will be assigned to a newly added workspace."

	^ nextWorkspaceHandle
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AIWorkspaceRegistry >> notifyWorkspacesChanged [

	chat changedWorkspaces
]

{ #category : 'Actions' }
AIWorkspaceRegistry >> reattachWorkspaces [

	workspaces keysAndValuesDo: [ :key :workspace |
		workspace ifNotNil: [ self registerDestroyCallbackFor: workspace ] ]
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIWorkspaceRegistry >> registerDestroyCallbackFor: aWorkspace [

	aWorkspace shell ifNotNil: [ :shell |
		shell isDestroyed ifFalse: [
			"First remove any existing matching callback so it is idempotent if multiple AIChatWindows reattach."
			shell
				removeCallback: CwConstants::XmNdestroyCallback
				receiver: self
				selector: #workspaceDestroyed:clientData:callData:
				clientData: aWorkspace;
				addCallback: CwConstants::XmNdestroyCallback
				receiver: self
				selector: #workspaceDestroyed:clientData:callData:
				clientData: aWorkspace ] ]
]

{ #category : 'Actions' }
AIWorkspaceRegistry >> remove: aWorkspace [

	| key |
	key := workspaces keyAtValue: aWorkspace ifAbsent: [ ^ self ].
	aWorkspace shell ifNotNil: [ :shell |
		shell isDestroyed ifFalse: [
			shell
				removeCallback: CwConstants::XmNdestroyCallback
				receiver: self
				selector: #workspaceDestroyed:clientData:callData:
				clientData: aWorkspace ] ].
	workspaces removeKey: key.
	self notifyWorkspacesChanged
]

{ #category : 'Events',
  #vaVisibility : 'private' }
AIWorkspaceRegistry >> workspaceDestroyed: widget clientData: aWorkspace callData: callData [

	| key |
	key := workspaces keyAtValue: aWorkspace ifAbsent: [ ^ self ].
	workspaces at: key put: nil.
	self notifyWorkspacesChanged
]

{ #category : 'Accessing' }
AIWorkspaceRegistry >> workspaces [

	| changed |
	changed := false.
	workspaces keysAndValuesDo: [ :key :workspace |
		(workspace notNil and: [ (self class isWorkspaceValid: workspace) not ]) ifTrue: [
			workspaces at: key put: nil.
			changed := true ] ].
	changed ifTrue: [
		CwAppContext default asyncExecInUI: [ self notifyWorkspacesChanged ] ].
	^ workspaces
]
