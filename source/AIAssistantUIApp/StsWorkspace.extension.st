Extension {
	#name : 'StsWorkspace'
}

{ #category : 'AI Assistant' }
StsWorkspace class >> allOpenWorkspaces [
	"Answer a collection of all open and active workspaces."

	^ EtWindow allWindows select: [ :window |
		(window isKindOf: StsWorkspace) and: [ window isWorkspaceClosed not ] ]
]

{ #category : 'AI Assistant' }
StsWorkspace >> isWorkspaceClosed [
	"Answer whether the workspace shell is closed or destroyed."

	^ shell isNil or: [ shell isDestroyed ]
]

{ #category : 'AI Assistant' }
StsWorkspace >> shareWithAIAssistant [
	"Share this workspace with an AI Chat window."

	| openWindows prompter selected chatWindow |

	openWindows := AIChatWindow allInstances select: [ :each | each chatIsAvailableForUserMessage ].
	openWindows isEmpty ifTrue: [
		chatWindow := AIChatWindow new.
		chatWindow open.
		chatWindow addWorkspace: self.
		^ self ].

	prompter := AIChatListPrompter new
		title: 'Share Workspace with AI Assistant';
		messageString: 'Select an available chat or create a new chat.';
		button1Name: 'Select';
		button2Name: 'Cancel';
		button3Name: 'New Chat Window';
		items: (openWindows sorted: [ :w1 :w2 | (w1 label ifNil: [ '' ]) <= (w2 label ifNil: [ '' ]) ]);
		printBlock: [ :window | window label ifNil: [ '' ] ].

	selected := prompter prompt.
	selected ifNil: [ ^ self ].
	selected == #newChatWindow ifTrue: [
		chatWindow := AIChatWindow new.
		chatWindow open.
		chatWindow addWorkspace: self.
		^ self ].

	selected addWorkspace: self.
	selected bringToFront
]

{ #category : 'AI Assistant' }
StsWorkspace >> updateToolBar [
	"Recreate the workspace toolbar and update widget attachments."

	| height textWidgetParent |

	toolBar ifNil: [ ^ self ].
	height := toolBar destroyWidget; height.
	toolBar := self stsToolBar.
	toolBar ifNotNil: [
		toolBar height: height.
		toolBar setValuesBlock: [ :w |
			w
				topAttachment: XmATTACHFORM;
				leftAttachment: XmATTACHFORM;
				rightAttachment: XmATTACHFORM ] ].
	textWidgetParent := self parentForWidgetAttachments: textWidget.
	textWidgetParent setValuesBlock: [ :w |
		toolBar isNil
			ifTrue: [ w topAttachment: XmATTACHFORM ]
			ifFalse: [
				w
					topAttachment: XmATTACHWIDGET;
					topWidget: toolBar ].
		w
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM ]
]

{ #category : 'AI Assistant' }
StsWorkspace >> userLabel: newUserLabel [

	userLabel := newUserLabel
]

{ #category : 'AI Assistant' }
StsWorkspace >> workspaceContents [
	"Answer the current text in the workspace."

	textWidget ifNil: [ ^ '' ].
	(textWidget respondsTo: #isDestroyed) ifTrue: [
		textWidget isDestroyed ifTrue: [ ^ '' ] ].
	^ textWidget getString asString
]

{ #category : 'AI Assistant' }
StsWorkspace >> workspaceVariables [
	"Answer the dictionary of workspace variables."

	^ workspaceVariables
]
