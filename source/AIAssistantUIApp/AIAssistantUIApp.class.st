Class {
	#name : 'AIAssistantUIApp',
	#superclass : 'Application',
	#category : 'AIAssistantUIApp'
}

{ #category : 'Not categorized' }
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

{ #category : 'Not categorized' }
AIAssistantUIApp class >> loaded [

	self addToSystemMenu
]

{ #category : 'Not categorized' }
AIAssistantUIApp class >> openChatWindow [

	AIChatWindow new open
]

{ #category : 'Not categorized' }
AIAssistantUIApp class >> removeFromSystemMenu [

	System systemMenu remove: #openChatWindow ifAbsent: [ ].
	System updateTranscriptMenus
]

{ #category : 'Not categorized' }
AIAssistantUIApp class >> removing [

	self removeFromSystemMenu.
	AIChatWidget resetFontSets.
]

{ #category : 'Not categorized' }
AIAssistantUIApp class >> shutDown [

	AIChatWidget resetFontSets
]
