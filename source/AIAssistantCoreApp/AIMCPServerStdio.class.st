Class {
	#name : 'AIMCPServerStdio',
	#superclass : 'AIAbstractMCPServer',
	#instVars : [
		'command',
		'processSemaphore',
		'process',
		'stderrLines',
		'stderrReadingProcessQueue',
		'stderrReaderProcess'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIMCPServerStdio class >> label [

	^ 'Stdio'
]

{ #category : 'Not categorized' }
AIMCPServerStdio class >> name: serverName [

	^ self name: serverName command: nil
]

{ #category : 'Not categorized' }
AIMCPServerStdio class >> name: serverName command: command [

	^ self basicNew initializeWithName: serverName command: command
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> call: methodName id: id with: methodArguments do: block [

	self ensureStderrReaderProcess.
	process inputStream
		nextPutAll: ((AIJSONWriter toString: (self jsonRPCObjectCalling: methodName id: id with: methodArguments)) , String lf) asUtf8Bytes;
		flush.
	^ block cull: (id ifNotNil: [
		| characterStream json |
		characterStream := AIPeekableStream on: (AICharacterGraphemeStream on: (AIUTF8DecodingStream on: process outputStream nextLine readStream)).
		json := (NeoJSONReader on: characterStream) next.
		characterStream atEnd ifFalse: [
			Error signal: 'Stream unexpectedly not at end' ].
		json at: 'result' ])
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> call: methodName with: methodArguments [

	^ processSemaphore critical: [
		(process notNil and: [ process isComplete not ]) ifFalse: [
			| processStarter |
			processStarter := OsProcessStarter shell: #('%COMMAND%').
			processStarter environment at: 'COMMAND' put: command.
			process := processStarter start.
			{ process inputStream. process outputStream. process errorStream } do: [ :stream | stream isBytes: true ].
			stderrReadingProcessQueue add: process.
			CwAppContext default syncExecInUI: [
				self changed: #isRunning; changed: #hasExitError ].
			self call: 'initialize' id: UUID new asString with: self initializeArguments do: [ ].
			self call: 'notifications/initialized' id: nil with: nil do: [ ] ].
		self call: methodName id: UUID new asString with: methodArguments do: [ :result | result ] ]
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIMCPServerStdio >> clearProcess [

	process ifNotNil: [ :oldProcess |
		[
			processSemaphore critical: [
				process == oldProcess ifTrue: [
					process := nil.
					CwAppContext default syncExecInUI: [
						self changed: #isRunning; changed: #hasExitError ] ] ].
			oldProcess inputStream close.
			[
				(Delay forSeconds: 5) wait.
				oldProcess isComplete ifFalse: [
					oldProcess terminate.
					(Delay forSeconds: 5) wait.
					oldProcess isComplete ifFalse: [
						oldProcess kill.
						(Delay forSeconds: 1) wait.
						oldProcess isComplete ifFalse: [
							Error signal: ('Could not kill old process %1 of %2 named "%3"' bindWith: oldProcess with: self class with: self name) ] ] ]
			] when: ExError , OsProcessException do: [ :error |
				(Delay forSeconds: 1) wait.
				oldProcess isComplete ifTrue: [ error return ] ifFalse: [ error pass ] ]
		] fork ]
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> command [

	^ command
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> command: newCommand [

	newCommand = command ifFalse: [
		self clearProcess ].
	command := newCommand.
	self changed: #command.
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIMCPServerStdio >> ensureStderrReaderProcess [

	stderrReaderProcess isDead ifFalse: [ ^ self ].
	stderrReaderProcess :=
		[
			[
				| readProcess lineByteArray |
				readProcess := stderrReadingProcessQueue removeFirst.
				[
					(lineByteArray := (readProcess isComplete not or: [ readProcess errorStream atEnd not ]) ifTrue: [
						[ readProcess errorStream nextLine ] when: ExError , OsProcessException do: [ :error |
							(Delay forSeconds: 1) wait.
							readProcess isComplete ifTrue: [ error return ] ifFalse: [ error pass ] ] ]) notNil
				] whileTrue: [
					| lineString |
					lineString := UnicodeString utf8: lineByteArray repair: true.
					CwAppContext default syncExecInUI: [
						stderrLines add: (stderrLines ifEmpty: [ 1 ] ifNotEmpty: [ stderrLines last key + 1 ]) -> lineString.
						stderrLines size > 1000 ifTrue: [
							stderrLines removeFirst ].
						self changed: #stderrLines ] ].
				CwAppContext default syncExecInUI: [
					readProcess == process ifTrue: [
						self changed: #isRunning; changed: #hasExitError ] ].
				true
			] whileTrue
		] fork.
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> hasExitError [

	^ process notNil and: [ process isComplete and: [ process exitCode notNil and: [ process exitCode > 0 ] ] ]
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> initializeWithName: initialName command: initialCommand [

	self initializeWithName: initialName.
	command := initialCommand.
	processSemaphore := Semaphore forMutualExclusion.
	stderrLines := OrderedCollection new.
	stderrReadingProcessQueue := SstSharedQueue new.
	self ensureStderrReaderProcess.
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> isRunning [

	^ process notNil and: [ process isComplete not ]
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> isStdio [

	^ true
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> removed [

	super removed.
	self clearProcess.
	stderrReaderProcess terminate.
]

{ #category : 'Not categorized' }
AIMCPServerStdio >> stderrLines [

	^ stderrLines copy
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIMCPServerStdio >> terminateStderrReaderProcess [

	stderrReaderProcess terminate
]
