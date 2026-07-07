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
AIAssistantUIApp class >> failedRemove [

	self hookDebuggerMenuCallbacks.
	self addToSystemMenu
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
AIAssistantUIApp class >> removing [

	self releaseDebuggerMenuCallbacks.
	self removeFromSystemMenu.
	AIChatWidget resetFontSets.
]

{ #category : 'Internal' }
AIAssistantUIApp class >> shutDown [

	AIChatWidget resetFontSets
]
