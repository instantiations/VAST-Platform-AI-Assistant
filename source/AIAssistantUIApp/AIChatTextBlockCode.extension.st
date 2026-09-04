Extension {
	#name : 'AIChatTextBlockCode'
}

{ #category : 'Widget Event Handling' }
AIChatTextBlockCode >> browse [
	self openWorkspace
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockCode >> buttonPressedIn: chatWidget [

	CwAppContext default asyncExecInUI: [
		self browse ]
]

{ #category : 'Accessing' }
AIChatTextBlockCode >> codeAssistProvider [

	| language contentType |

	language := ((self infoString ifNil: [ '' ]) splitOn: Character space) first asLowercase.
	contentType := (#(
		(text ('text' ''))
		(smalltalk ('smalltalk'))
		(asm ('assembly' 'asm'))
		(batch ('batch' 'bat'))
		(cpp ('cpp' 'c'))
		(cmake ('cmake'))
		(css ('css'))
		(diff ('diff'))
		(go ('go' 'golang'))
		(html ('html'))
		(ini ('ini'))
		(java ('java'))
		(javascript ('javascript' 'js' 'typescript' 'ts'))
		(json ('json'))
		(makefile ('makefile' 'make'))
		(markdown ('markdown' 'md'))
		(php ('php'))
		(powershell ('powershell' 'pwsh' 'ps1'))
		(python ('python' 'py'))
		(rc ('rc'))
		(ruby ('ruby' 'rb'))
		(rust ('rust' 'rs'))
		(shell ('shell' 'sh' 'bash'))
		(sql ('sql'))
		(swift ('swift'))
		(vb ('vb' 'vbnet'))
		(xml ('xml')))
			detect: [ :array | array second includes: language ] ifNone: [ #(text) ]) first.
	((StsCodeAssist providersForContentType: contentType) ifEmpty: [ (StsCodeAssist providersForContentType: #text) ifEmpty: [ Error signal: 'Could not find provider for content type #text' ] ])
		do: [ :provider | ^ provider ]
]

{ #category : 'Drawing' }
AIChatTextBlockCode >> drawOnChatWidget: chatWidget dc: dc [

	chatWidget drawTextBlockCode: self dc: dc
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockCode >> openWorkspace [

	| workspace |
	
	(workspace := StsWorkspace new)
		userLabel: 'AI Assistant Workspace';
		open;
		nextPutAll: self code.
	workspace textWidget codeAssistant updateActiveProvider: self codeAssistProvider
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockCode >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Widget Event Handling' }
AIChatTextBlockCode >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Writing' }
AIChatTextBlockCode >> writeFormattedOn: stream [

	| numberOfTicks backticks |

	numberOfTicks := 3.
	code linesDo: [ :line |
		line size >= 3 ifTrue: [
			| startIndex stopIndex |
			startIndex := (1 to: 3) detect: [ :index | (line at: index) ~= Character space ] ifNone: [ 4 ].
			stopIndex := (startIndex to: line size) detect: [ :index | (line at: index) ~= $` ] ifNone: [ line size + 1 ].
			numberOfTicks := numberOfTicks max: (stopIndex - startIndex + 1) ] ].
	
	backticks := String new: numberOfTicks withAll: $`.
	
	stream nextPutAll: backticks.
	infoString ifNotNil: [
		stream nextPutAll: infoString ].
	stream newLine.
	stream nextPutAll: code.
	stream newLine.
	stream nextPutAll: backticks.
]
