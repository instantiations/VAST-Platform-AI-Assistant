Extension {
	#name : 'DbgDebugger'
}

{ #category : 'AI-Extensions' }
DbgDebugger >> askAIToInvestigate [
	"Ask the AI Assistant to investigate the selected process."
	
	| openWindows prompter selected chatWindow |
	self isOneSessionSelected ifFalse: [ ^self ].
	
	openWindows := AIChatWindow allInstances select: [:each | each chatIsAvailableForUserMessage].
	
	openWindows isEmpty ifTrue: [
		chatWindow := AIChatWindow new.
		chatWindow open.
		^self askAIToInvestigateInChatWindow: chatWindow].
	
	prompter :=AIChatListPrompter new
		title: 'Ask AI to Investigate';
		messageString: 'Select an available chat or create a new chat.';
		button1Name: 'Select';
		button2Name: 'Cancel';
		button3Name: 'New Chat Window';
		items: (openWindows sorted: [:w1 :w2 | w1 label <= w2 label ]) ;
		printBlock: [:window | window label ].

	selected := prompter prompt.
	
	selected ifNil: [ ^self ].
	selected == #newChatWindow ifTrue: [
		chatWindow := AIChatWindow new.
		chatWindow open.
		^self askAIToInvestigateInChatWindow: chatWindow].

	self askAIToInvestigateInChatWindow: selected
]

{ #category : 'AI-Extensions',
  #vaVisibility : 'private' }
DbgDebugger >> askAIToInvestigateInChatWindow: chatWindow [
	"Ask the AI Assistant to investigate the selected process in the given chat window."

	(chatWindow
		bringToFront;
		acceptNewUserMessage: 'A debugger just opened. Investigate the suspended process.')
			ifFalse: [ 
				"We should never end up here because the window selection dialog is a modal dialog, but this is a failsafe"
				CwMessagePrompter errorMessage: 'The selected chat is not available anymore (either busy or closed).']
]
