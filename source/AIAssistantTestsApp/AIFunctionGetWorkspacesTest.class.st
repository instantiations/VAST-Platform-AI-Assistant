Class {
	#name : 'AIFunctionGetWorkspacesTest',
	#superclass : 'AIFunctionTestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testClosedWorkspace [

	| chat closedWs activeWs context args result |

	chat := AITestChat new.
	closedWs := AIMockWorkspace new initialize.
	closedWs isWorkspaceClosed: true.

	chat addWorkspace: closedWs.
	context := self contextForChat: chat.
	args := EsOrderedDictionary with: 'workspace_handle' -> 1.

	"When all workspaces in the registry are closed, reports no workspaces shared"
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.
	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> 'No workspaces are currently shared with this chat.').

	"When at least one workspace is active, requesting the closed workspace by handle reports it was closed"
	activeWs := AIMockWorkspace new initialize.
	chat addWorkspace: activeWs.

	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.
	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> 'The workspace with handle 1 has been closed')
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testCrossWorkspaceObjectInspection [

	| chat mockWs1 mockWs2 point array context expectedPointJSON expectedArrayJSON result inspectArgs inspectResult |

	chat := AITestChat new.
	point := Point x: 10 y: 20.
	mockWs1 := AIMockWorkspace new initialize.
	mockWs1 label: 'Geometry'.
	mockWs1 workspaceVariables at: #pt put: point.

	array := Array with: 42 with: 'hello'.
	mockWs2 := AIMockWorkspace new initialize.
	mockWs2 label: 'Collections'.
	mockWs2 workspaceVariables at: #arr put: array.

	chat
		addWorkspace: mockWs1;
		addWorkspace: mockWs2.
	context := self contextForChat: chat.

	result := self applyFunction: AIFunctionGetWorkspaces withArguments: EsOrderedDictionary new inContext: context.

	expectedPointJSON := EsOrderedDictionary
		with: 'class' -> 'Point'
		with: 'print_string' -> '10 @ 20'
		with: 'object_handle' -> 1
		with: 'instance_variables' -> (EsOrderedDictionary
			with: 'x' -> (EsOrderedDictionary
				with: 'class' -> 'SmallInteger'
				with: 'print_string' -> '10'
				with: 'object_handle' -> 2)
			with: 'y' -> (EsOrderedDictionary
				with: 'class' -> 'SmallInteger'
				with: 'print_string' -> '20'
				with: 'object_handle' -> 3)).

	expectedArrayJSON := EsOrderedDictionary
		with: 'class' -> 'Array'
		with: 'object_handle' -> 4
		with: 'size' -> 2
		with: 'instance_variables' -> EsOrderedDictionary new
		with: 'elements' -> (OrderedCollection
			with: (EsOrderedDictionary
				with: 'class' -> 'SmallInteger'
				with: 'print_string' -> '42'
				with: 'object_handle' -> 5)
			with: (EsOrderedDictionary
				with: 'class' -> 'String'
				with: 'print_string' -> '''hello'''
				with: 'object_handle' -> 6)).

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspaces' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'workspace_handle' -> 1
					with: 'label' -> 'Geometry'
					with: 'contents' -> ''
					with: 'variables' -> (EsOrderedDictionary
						with: 'pt' -> expectedPointJSON))
				with: (EsOrderedDictionary
					with: 'workspace_handle' -> 2
					with: 'label' -> 'Collections'
					with: 'contents' -> ''
					with: 'variables' -> (EsOrderedDictionary
						with: 'arr' -> expectedArrayJSON)))).

	"Inspect point from workspace 1"
	inspectArgs := EsOrderedDictionary with: 'object_handle' -> 1.
	inspectResult := self applyFunction: AIFunctionInspectObject withArguments: inspectArgs inContext: context.
	self assert: inspectResult equals: expectedPointJSON.

	"Inspect array from workspace 2"
	inspectArgs := EsOrderedDictionary with: 'object_handle' -> 4.
	inspectResult := self applyFunction: AIFunctionInspectObject withArguments: inspectArgs inContext: context.
	self assert: inspectResult equals: expectedArrayJSON.

	"Inspect string element from array in workspace 2"
	inspectArgs := EsOrderedDictionary with: 'object_handle' -> 6.
	inspectResult := self applyFunction: AIFunctionInspectObject withArguments: inspectArgs inContext: context.
	self
		assert: inspectResult
		equals: (EsOrderedDictionary
			with: 'class' -> 'String'
			with: 'print_string' -> '''hello'''
			with: 'object_handle' -> 6)
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testIndexedLimit [

	| chat mockWs context args result arrJSON |

	chat := AITestChat new.
	mockWs := AIMockWorkspace new initialize.
	mockWs workspaceVariables at: #arr put: (1 to: 20) asArray.

	chat addWorkspace: mockWs.
	context := self contextForChat: chat.

	args := EsOrderedDictionary
		with: 'workspace_handle' -> 1
		with: 'indexed_limit' -> 4.

	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.
	arrJSON := (result at: 'variables') at: 'arr'.

	self assert: (arrJSON at: 'class') equals: 'Array'.
	self assert: (arrJSON at: 'size') equals: 20.
	self assert: (arrJSON at: 'elements') size equals: 4
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testInvalidWorkspaceHandle [

	| chat mockWs context args result |

	chat := AITestChat new.
	mockWs := AIMockWorkspace new initialize.
	chat addWorkspace: mockWs.
	context := self contextForChat: chat.

	args := EsOrderedDictionary with: 'workspace_handle' -> 99.

	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> 'There is no workspace with handle 99')
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testMultipleWorkspaces [

	| chat mockWs1 mockWs2 context result |

	chat := AITestChat new.
	mockWs1 := AIMockWorkspace new initialize.
	mockWs1 label: 'Workspace One'.
	mockWs1 workspaceContents: 'a := 1.'.
	mockWs1 workspaceVariables at: #a put: 1.

	mockWs2 := AIMockWorkspace new initialize.
	mockWs2 label: 'Workspace Two'.
	mockWs2 workspaceContents: 'b := 2.'.
	mockWs2 workspaceVariables at: #b put: 2.

	chat
		addWorkspace: mockWs1;
		addWorkspace: mockWs2.
	context := self contextForChat: chat.
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: EsOrderedDictionary new inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspaces' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'workspace_handle' -> 1
					with: 'label' -> 'Workspace One'
					with: 'contents' -> 'a := 1.'
					with: 'variables' -> (EsOrderedDictionary
						with: 'a' -> (EsOrderedDictionary
							with: 'class' -> 'SmallInteger'
							with: 'print_string' -> '1'
							with: 'object_handle' -> 1
							with: 'instance_variables' -> EsOrderedDictionary new)))
				with: (EsOrderedDictionary
					with: 'workspace_handle' -> 2
					with: 'label' -> 'Workspace Two'
					with: 'contents' -> 'b := 2.'
					with: 'variables' -> (EsOrderedDictionary
						with: 'b' -> (EsOrderedDictionary
							with: 'class' -> 'SmallInteger'
							with: 'print_string' -> '2'
							with: 'object_handle' -> 2
							with: 'instance_variables' -> EsOrderedDictionary new)))))
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testNoWorkspacesShared [

	| chat context result |

	chat := AITestChat new.
	context := self contextForChat: chat.
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: EsOrderedDictionary new inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> 'No workspaces are currently shared with this chat.')
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testPrintStringLimit [

	| chat mockWs longString context args result |

	chat := AITestChat new.
	longString := String new: 500 withAll: $x.
	mockWs := AIMockWorkspace new initialize.
	mockWs workspaceVariables at: #str put: longString.

	chat addWorkspace: mockWs.
	context := self contextForChat: chat.

	args := EsOrderedDictionary
		with: 'workspace_handle' -> 1
		with: 'printstring_limit' -> 15.

	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspace_handle' -> 1
			with: 'label' -> 'Mock Workspace'
			with: 'contents' -> ''
			with: 'variables' -> (EsOrderedDictionary
				with: 'str' -> (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> (longString printStringLimitedTo: 15)
					with: 'object_handle' -> 1)))
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testRealStsWorkspaceIntegration [

	| workspace chat expression context expectedPointJSON result inspectResult |

	CwAppContext default syncExecInUI: [
		expression := 'myPoint := 10 @ 20.'.
		workspace := StsWorkspace new.
		workspace userLabel: 'Real Test Workspace'.
		workspace open.

		[
			self assert: (StsWorkspace allOpenWorkspaces includes: workspace).
			self deny: workspace isWorkspaceClosed.

			workspace nextPutAll: expression.
			workspace textWidget setSelection: (0 @ expression size).
			workspace evaluateSelectionIn: workspace textWidget ifFail: [ self fail ].

			chat := AITestChat new.
			chat addWorkspace: workspace.
			self assert: (chat activeWorkspaces includes: workspace).

			context := self contextForChat: chat.

			expectedPointJSON := EsOrderedDictionary
				with: 'class' -> 'Point'
				with: 'print_string' -> '10 @ 20'
				with: 'object_handle' -> 1
				with: 'instance_variables' -> (EsOrderedDictionary
					with: 'x' -> (EsOrderedDictionary
						with: 'class' -> 'SmallInteger'
						with: 'print_string' -> '10'
						with: 'object_handle' -> 2)
					with: 'y' -> (EsOrderedDictionary
						with: 'class' -> 'SmallInteger'
						with: 'print_string' -> '20'
						with: 'object_handle' -> 3)).

			result := self applyFunction: AIFunctionGetWorkspaces withArguments: EsOrderedDictionary new inContext: context.
			self
				assert: result
				equals: (EsOrderedDictionary
					with: 'workspaces' -> (OrderedCollection
						with: (EsOrderedDictionary
							with: 'workspace_handle' -> 1
							with: 'label' -> 'Real Test Workspace'
							with: 'contents' -> expression
							with: 'variables' -> (EsOrderedDictionary
								with: 'myPoint' -> expectedPointJSON)))).

			inspectResult := self
				applyFunction: AIFunctionInspectObject
				withArguments: (EsOrderedDictionary with: 'object_handle' -> 1)
				inContext: context.
			self assert: inspectResult equals: expectedPointJSON.

			workspace stsClose.
			self assert: workspace isWorkspaceClosed.
			self assert: chat activeWorkspaces isEmpty.

			result := self
				applyFunction: AIFunctionGetWorkspaces
				withArguments: (EsOrderedDictionary with: 'workspace_handle' -> 1)
				inContext: context.
			self
				assert: result
				equals: (EsOrderedDictionary with: 'error' -> 'No workspaces are currently shared with this chat.').
			self assert: (chat workspaces includesKey: 1).
			self assert: (chat workspaces at: 1) isNil
		] ensure: [
			(workspace notNil and: [ workspace isWorkspaceClosed not ]) ifTrue: [ workspace stsClose ] ] ]
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testReopenedChatPreservesNextWorkspaceHandleCounter [
	"Verify that saving and reopening an AIChat preserves the workspaceRegistry nextWorkspaceHandle counter."

	| chat mockWs1 mockWs2 storedString reopenedChat mockWs3 context result |
	chat := AIChat
		systemInstruction: 'Test instruction'
		model: AIChatTest testModels first
		filePaths: OrderedCollection new
		userMessages: OrderedCollection new.

	mockWs1 := AIMockWorkspace new initialize.
	mockWs1 label: 'Workspace 1'.
	mockWs2 := AIMockWorkspace new initialize.
	mockWs2 label: 'Workspace 2'.
	chat addWorkspace: mockWs1.
	chat addWorkspace: mockWs2.
	self assert: chat workspaceRegistry nextWorkspaceHandle equals: 3.

	storedString := String streamContents: [ :stream | chat storeOn: stream ].
	reopenedChat := Compiler evaluate: storedString.

	self assert: reopenedChat workspaceRegistry nextWorkspaceHandle equals: 3.

	mockWs3 := AIMockWorkspace new initialize.
	mockWs3 label: 'Workspace 3'.
	reopenedChat addWorkspace: mockWs3.

	context := self contextForChat: reopenedChat.

	result := self applyFunction: AIFunctionGetWorkspaces withArguments: EsOrderedDictionary new inContext: context.
	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspaces' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'workspace_handle' -> 3
					with: 'label' -> 'Workspace 3'
					with: 'contents' -> ''
					with: 'variables' -> EsOrderedDictionary new)))
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testSingleWorkspaceAllWorkspaces [

	| chat mockWs context result |

	chat := AITestChat new.
	mockWs := AIMockWorkspace new initialize.
	mockWs label: 'Test Workspace'.
	mockWs workspaceContents: 'x := 10.'.
	mockWs workspaceVariables at: #x put: 10.

	chat addWorkspace: mockWs.
	context := self contextForChat: chat.
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: EsOrderedDictionary new inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspaces' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'workspace_handle' -> 1
					with: 'label' -> 'Test Workspace'
					with: 'contents' -> 'x := 10.'
					with: 'variables' -> (EsOrderedDictionary
						with: 'x' -> (EsOrderedDictionary
							with: 'class' -> 'SmallInteger'
							with: 'print_string' -> '10'
							with: 'object_handle' -> 1
							with: 'instance_variables' -> EsOrderedDictionary new)))))
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testSingleWorkspaceByHandle [

	| chat mockWs context args result |

	chat := AITestChat new.
	mockWs := AIMockWorkspace new initialize.
	mockWs label: 'Test Workspace'.
	mockWs workspaceContents: 'name := ''VAST''.'.
	mockWs workspaceVariables at: #name put: 'VAST'.

	chat addWorkspace: mockWs.
	context := self contextForChat: chat.
	args := EsOrderedDictionary with: 'workspace_handle' -> 1.

	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.

	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspace_handle' -> 1
			with: 'label' -> 'Test Workspace'
			with: 'contents' -> 'name := ''VAST''.'
			with: 'variables' -> (EsOrderedDictionary
				with: 'name' -> (EsOrderedDictionary
					with: 'class' -> 'String'
					with: 'print_string' -> '''VAST'''
					with: 'object_handle' -> 1)))
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testStableWorkspaceHandlesAfterRemoveAndClose [

	| chat mockWs1 mockWs2 mockWs3 context result args |

	chat := AITestChat new.
	mockWs1 := AIMockWorkspace new initialize.
	mockWs1 label: 'Workspace 1'.
	mockWs2 := AIMockWorkspace new initialize.
	mockWs2 label: 'Workspace 2'.
	mockWs3 := AIMockWorkspace new initialize.
	mockWs3 label: 'Workspace 3'.

	chat addWorkspace: mockWs1.
	chat addWorkspace: mockWs2.
	chat addWorkspace: mockWs3.

	"Remove Workspace 1 and close Workspace 2"
	chat removeWorkspace: mockWs1.
	mockWs2 isWorkspaceClosed: true.

	context := self contextForChat: chat.

	"Closed Workspace 2 reference is cleaned up to nil while preserving key 2"
	self assert: (chat workspaces includesKey: 1) not.
	self assert: (chat workspaces includesKey: 2).
	self assert: (chat workspaces at: 2) isNil.
	self assert: (chat workspaces at: 3) == mockWs3.

	"All workspaces: Workspace 2 reports closed with handle 2, Workspace 3 stays handle 3"
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: EsOrderedDictionary new inContext: context.
	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspaces' -> (OrderedCollection
				with: (EsOrderedDictionary
					with: 'error' -> 'The workspace with handle 2 has been closed')
				with: (EsOrderedDictionary
					with: 'workspace_handle' -> 3
					with: 'label' -> 'Workspace 3'
					with: 'contents' -> ''
					with: 'variables' -> EsOrderedDictionary new))).

	"Requesting removed Workspace 1 reports no workspace with handle 1"
	args := EsOrderedDictionary with: 'workspace_handle' -> 1.
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.
	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> 'There is no workspace with handle 1').

	"Requesting closed Workspace 2 reports closed"
	args := EsOrderedDictionary with: 'workspace_handle' -> 2.
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.
	self
		assert: result
		equals: (EsOrderedDictionary with: 'error' -> 'The workspace with handle 2 has been closed').

	"Requesting active Workspace 3 still resolves to Workspace 3"
	args := EsOrderedDictionary with: 'workspace_handle' -> 3.
	result := self applyFunction: AIFunctionGetWorkspaces withArguments: args inContext: context.
	self
		assert: result
		equals: (EsOrderedDictionary
			with: 'workspace_handle' -> 3
			with: 'label' -> 'Workspace 3'
			with: 'contents' -> ''
			with: 'variables' -> EsOrderedDictionary new)
]

{ #category : 'Tests' }
AIFunctionGetWorkspacesTest >> testWorkspaceRegistryNotifiesChat [
	"Verify that AIWorkspaceRegistry notifies its AIChat via #changedWorkspaces when workspaces are added or removed."

	| chat mockWs |
	chat := AITestChat new.
	mockWs := AIMockWorkspace new initialize.

	self assert: chat changedWorkspacesCount equals: 0.

	chat addWorkspace: mockWs.
	self assert: chat changedWorkspacesCount equals: 1.

	"Adding an already-registered workspace does not trigger another notification"
	chat addWorkspace: mockWs.
	self assert: chat changedWorkspacesCount equals: 1.

	chat removeWorkspace: mockWs.
	self assert: chat changedWorkspacesCount equals: 2
]
