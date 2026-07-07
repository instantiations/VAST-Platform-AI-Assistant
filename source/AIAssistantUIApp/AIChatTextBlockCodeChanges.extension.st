Extension {
	#name : 'AIChatTextBlockCodeChanges'
}

{ #category : 'Not categorized' }
AIChatTextBlockCodeChanges >> browse [

	CwAppContext default asyncExecInUI: [AIRefactoryChangesBrowser openOn: changes]
]

{ #category : 'Not categorized' }
AIChatTextBlockCodeChanges >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockCodeChanges: self dc: dc
]

{ #category : 'Accessing' }
AIChatTextBlockCodeChanges >> textElement [

	^textElement ifNil: [
		textElement := AIChatTextElementAction
			element: (AIChatTextElementString string: ('Browse %1 suggested %2'
				bindWith: changes size asString
				with: (changes size = 1 ifTrue: [ 'change' ] ifFalse: [ 'changes' ])))
			block: [self browse] ]
]
