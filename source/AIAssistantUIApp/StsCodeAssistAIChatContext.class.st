Class {
	#name : 'StsCodeAssistAIChatContext',
	#superclass : 'StsCodeAssistWorkspaceContext',
	#category : 'AIAssistantUIApp'
}

{ #category : 'Defaults' }
StsCodeAssistAIChatContext class >> defaultSupportedContentTypes [

	^#(smalltalk)
]

{ #category : 'API' }
StsCodeAssistAIChatContext >> canProvideAutoPopupCompletionSuggestions [

	^false
]

{ #category : 'Sc Code Assist' }
StsCodeAssistAIChatContext >> scPostConnect [

	self contentAssistant styler useColor: false.
	self window
		stsSetFontListFor: self contentAssistant scEditor;
		updateInput
]

{ #category : 'Sc Lexer' }
StsCodeAssistAIChatContext >> scintillaStylerClass [

	^StsScintillaStyler
]
