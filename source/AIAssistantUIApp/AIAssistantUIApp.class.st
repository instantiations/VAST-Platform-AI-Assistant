Class {
	#name : 'AIAssistantUIApp',
	#superclass : 'Application',
	#category : 'AIAssistantUIApp'
}

{ #category : 'Internal' }
AIAssistantUIApp class >> addSessionsEntries: receiver clientData: clientData callData: menu [
	"Add an 'Ask AI' menu item to the debugger processes menu"

	menu add: #askAIToInvestigate label: 'Ask AI to Investigate...' enable: true for: menu owner
]

{ #category : 'Internal' }
AIAssistantUIApp class >> addToSystemMenu [

	System image isRunningImage ifTrue: [ | aMenu |
		( aMenu := System systemMenu )
			ifNil: [ ^self ]. "No system menu"
		( aMenu findEntryNamed: #openChatWindow)
			ifNotNil:  [ ^self ]. "#openChatWindow already defined"

		aMenu
			add: #openChatWindow
			label: 'AI Assistant'
			enable: true
			for: self ]
]

{ #category : 'Internal' }
AIAssistantUIApp class >> addToTranscriptToolbar [

	| toolBar |

	StsPowerTools commandNameMap at: #stsAIAssistant put: 'AI Assistant'.
	toolBar := StsPowerTools toolBarDefinitionFor: Transcript class name ifAbsent: [ StsPowerTools toolBars at: Transcript class name put: Transcript stsDefaultToolBar ].
	(toolBar includes: #stsAIAssistant) ifFalse: [
		toolBar add: #space; add: #stsAIAssistant.
		self updateTranscriptToolbar ].
]

{ #category : 'Internal' }
AIAssistantUIApp class >> failedRemove [

	self hookDebuggerMenuCallbacks.
	self addToSystemMenu.
	self addToTranscriptToolbar.
]

{ #category : 'Internal' }
AIAssistantUIApp class >> hookDebuggerMenuCallbacks [
	"Register the application to add an 'Ask AI' menu item to the debugger processes menu."

	EtBaseDebugTools
		addCallback: #createSessionsMenuCallback
		receiver: self
		selector: #addSessionsEntries:clientData:callData:
		clientData: nil
]

{ #category : 'Internal' }
AIAssistantUIApp class >> loaded [

	self addToSystemMenu.
	self addToTranscriptToolbar.
	self releaseDebuggerMenuCallbacks.
	self hookDebuggerMenuCallbacks
]

{ #category : 'Internal' }
AIAssistantUIApp class >> openChatWindow [

	AIChatWindow new open
]

{ #category : 'Internal' }
AIAssistantUIApp class >> releaseDebuggerMenuCallbacks [
	"Release callbacks that allow the receiver to add to debugger menus."

	EtBaseDebugTools
		removeCallback: #createSessionsMenuCallback
		receiver: self
		selector: #addSessionsEntries:clientData:callData:
		clientData: nil
]

{ #category : 'Internal' }
AIAssistantUIApp class >> removeFromSystemMenu [

	System systemMenu remove: #openChatWindow ifAbsent: [ ].
	System updateTranscriptMenus
]

{ #category : 'Internal' }
AIAssistantUIApp class >> removeFromTranscriptToolbar [

	StsPowerTools toolBars at: Transcript class name ifPresent: [ :toolBar |
		| index |
		index := toolBar indexOf: #stsAIAssistant.
		index ~= 0 ifTrue: [
			toolBar removeAtIndex: index. 
			(index = (toolBar size + 1) and: [ index > 1 and: [ (toolBar at: index - 1) = #space ] ]) ifTrue: [
				toolBar removeAtIndex: index - 1 ].
			self updateTranscriptToolbar ] ].
	StsPowerTools commandNameMap removeKey: #stsAIAssistant ifAbsent: [ ].
]

{ #category : 'Internal' }
AIAssistantUIApp class >> removing [

	self releaseDebuggerMenuCallbacks.
	self removeFromSystemMenu.
	self removeFromTranscriptToolbar.
	AIChatWidget resetFontSets.
]

{ #category : 'Internal' }
AIAssistantUIApp class >> shutDown [

	AIChatWidget resetFontSets
]

{ #category : 'Internal' }
AIAssistantUIApp class >> updateTranscriptToolbar [

	| height |

	height := (Transcript instVarNamed: 'toolBar') destroyWidget; height.
	(Transcript instVarNamed: 'toolBar' put: Transcript stsToolBar) height: height.
	Transcript setAttachments.
]
