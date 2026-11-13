Class {
	#name : 'AITestChat',
	#superclass : 'AIChat',
	#instVars : [
		'changedWorkspacesCount'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Events' }
AITestChat >> changedWorkspaces [

	changedWorkspacesCount := self changedWorkspacesCount + 1.
	super changedWorkspaces
]

{ #category : 'Accessing' }
AITestChat >> changedWorkspacesCount [

	^ changedWorkspacesCount ifNil: [ 0 ]
]

{ #category : 'Generation' }
AITestChat >> generateTitleInBackground [

	"Do nothing"
]
