"
The Gemini Chat application is an integrated AI assistant for the VAST Platform, enabling direct interaction with Google's Gemini AI models within the Smalltalk environment.

Unlike a generic chat client, this application is context-aware of the VAST development environment. It exposes a set of 'Tools' (Functions) to the Gemini AI, allowing the model to perform introspection and validation tasks such as listing classes, finding method implementors, and validating Smalltalk code syntax.

Core Architectural Components:

1. Application Lifecycle (GeminiChatApp)
   - Manages the initialization and teardown of shared resources, such as the `GeminiLog` and `GeminiStandardFunctionsVAST`.

2. Chat Model (GeminiChat, GeminiModel)
   - `GeminiChat`: The central domain object managing the conversation state, including history (`GeminiContent`), the active `GeminiModel`, and system instructions.
   - `GeminiModel`: Represents the configuration of the specific Gemini AI model being used.

3. User Interface (GeminiChatWindow, GeminiChatWidget)
   - `GeminiChatWindow`: An `EtWindow` subclass that provides the main application window, integrating menus for file management, model selection, and debugging.
   - `GeminiChatWidget`: A custom UI widget (subclass of `CwExtendedPrimitive`) responsible for rendering the rich, streaming conversation content, including Markdown-formatted text and code blocks.

4. IDE Integration (GeminiStandardFunctionsVAST)
   - A bridge class that exposes VAST Platform capabilities to the AI as executable functions. This allows Gemini to query the system (e.g., `functionFindImplementors`, `functionGetClassDefinitions`) and assist with development tasks.

5. Content & Parsing (GeminiContent, GeminiColoredString*)
   - A suite of classes designed to parse and represent streaming responses from the API, handling structured content like text, code snippets (`GeminiColoredStringPartCode`), and thoughts/reasoning chains (`GeminiColoredStringPartThought`).

"
Class {
	#name : 'GeminiChatApp',
	#superclass : 'Application',
	#category : 'GeminiChatApp'
}

{ #category : 'Private' }
GeminiChatApp class >> addToSystemMenu [

	System image isRunningImage ifTrue: [ | aMenu |
		( aMenu := System systemMenu )
			ifNil: [ ^self ]. "No system menu"
		( aMenu findEntryNamed: #openGeminiAI)
			ifNotNil:  [ ^self ]. "#openGeminiAI already defined"

		aMenu
			add: #openGeminiAI
			label: 'Gemini AI Assistant'
			enable: true
			for: self ]
]

{ #category : 'Loading/Removing' }
GeminiChatApp class >> loaded [

	GeminiLog resetCurrent.
	self addToSystemMenu.
]

{ #category : 'Private' }
GeminiChatApp class >> openGeminiAI [

	GeminiChatWindow new open
]

{ #category : 'Private' }
GeminiChatApp class >> removeFromSystemMenu [

	System systemMenu remove: #openGeminiAI ifAbsent: [ ].
	System updateTranscriptMenus
]

{ #category : 'Loading/Removing' }
GeminiChatApp class >> removing [

	GeminiModel reset.
	GeminiLog clearCurrent.
]

{ #category : 'Loading/Removing' }
GeminiChatApp class >> shutDown [

	GeminiChatWidget resetFontSets
]

{ #category : 'Loading/Removing' }
GeminiChatApp class >> unload [

	self removeFromSystemMenu
]
