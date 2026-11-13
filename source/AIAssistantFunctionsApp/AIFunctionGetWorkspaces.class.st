Class {
	#name : 'AIFunctionGetWorkspaces',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionGetWorkspaces >> applyFunctionTo: arguments in: context [

	| workspaceRegistry stringLimit indexedLimit workspaceHandle workspaceList |

	workspaceRegistry := context workspaceRegistry.
	workspaceRegistry hasActiveWorkspaces ifFalse: [
		^ EsOrderedDictionary with: 'error' -> 'No workspaces are currently shared with this chat.' ].

	stringLimit := self printStringLimitFrom: arguments.
	indexedLimit := self indexedLimitFrom: arguments.
	workspaceHandle := arguments at: 'workspace_handle' ifAbsent: [ nil ].

	workspaceHandle ifNotNil: [
		| workspace |
		workspace := workspaceRegistry at: workspaceHandle ifAbsent: [
			^ EsOrderedDictionary with: 'error' -> ('There is no workspace with handle %1' bindWith: workspaceHandle) ].
		^ self
			jsonForWorkspace: workspace
			handle: workspaceHandle
			in: context
			printStringLimitedTo: stringLimit
			indexedLimitedTo: indexedLimit ].

	workspaceList := OrderedCollection new.
	workspaceRegistry keysAndValuesDo: [ :handle :workspace |
		workspaceList add: (self
			jsonForWorkspace: workspace
			handle: handle
			in: context
			printStringLimitedTo: stringLimit
			indexedLimitedTo: indexedLimit)].
	^ EsOrderedDictionary with: 'workspaces' -> workspaceList
]

{ #category : 'Accessing' }
AIFunctionGetWorkspaces >> category [

	^ 'Testing & Debugging'
]

{ #category : 'Accessing' }
AIFunctionGetWorkspaces >> description [

	^ 'Retrieves the contents and workspace variables of the workspaces currently shared with this chat. Variables are returned as serialized objects (including their class, object_handle, and their print string, instance variables, class variables, or elements, which can be inspected further with inspect_object). If workspace_handle is provided, returns only that workspace; otherwise returns all shared workspaces.'
]

{ #category : 'Testing',
  #vaVisibility : 'private' }
AIFunctionGetWorkspaces >> isWorkspaceValid: aWorkspace [

	^ AIWorkspaceRegistry isWorkspaceValid: aWorkspace
]

{ #category : 'Actions',
  #vaVisibility : 'private' }
AIFunctionGetWorkspaces >> jsonForWorkspace: workspace handle: handle in: context printStringLimitedTo: stringLimit indexedLimitedTo: indexedLimit [

	| dict variablesDict |
	(self isWorkspaceValid: workspace) ifFalse:[
		^ EsOrderedDictionary with: 'error' -> ('The workspace with handle %1 has been closed' bindWith: handle asString) ].

	dict := EsOrderedDictionary new.
	dict at: 'workspace_handle' put: handle.
	dict at: 'label' put: workspace label asString.
	dict at: 'contents' put: workspace workspaceContents asString.

	variablesDict := EsOrderedDictionary new.
	workspace workspaceVariables keysAndValuesDo: [:varName :varVal | | json |
		json :=
			[varVal aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit]
				on: Error
				do: [:ex |
					ex return:
						(EsOrderedDictionary with: 'error' -> 'Could not read workspace variable')].
		variablesDict at: varName asString put: json].
	dict at: 'variables' put: variablesDict.
	^dict
]

{ #category : 'Accessing' }
AIFunctionGetWorkspaces >> name [

	^ 'get_workspaces'
]

{ #category : 'Accessing' }
AIFunctionGetWorkspaces >> parameters [

	^ {
		AIFunctionParameterOptional
			name: 'workspace_handle'
			type: AIFunctionParameterTypeInteger new
			description: 'The handle of the workspace to retrieve. If omitted, all shared workspaces are returned.'.
		AIFunctionParameterOptional
			name: 'printstring_limit'
			type: AIFunctionParameterTypeInteger new
			description: 'The limit to use for the print string of variables, defaults to 200 and maxes out at 1000'.
		AIFunctionParameterOptional
			name: 'indexed_limit'
			type: AIFunctionParameterTypeInteger new
			description: 'The maximum number of elements to return for collection variables, defaults to 50 and maxes out at 1000' }
]
