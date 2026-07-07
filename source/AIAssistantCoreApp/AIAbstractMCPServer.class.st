Class {
	#name : 'AIAbstractMCPServer',
	#superclass : 'Object',
	#instVars : [
		'name',
		'tools'
	],
	#classVars : [
		'RegisteredServers'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractMCPServer class >> registerServer: server [

	self registeredServers add: server.
	self changed: #registeredServers.
]

{ #category : 'Not categorized' }
AIAbstractMCPServer class >> registeredServers [

	^ RegisteredServers ifNil: [ RegisteredServers := OrderedCollection new ]
]

{ #category : 'Not categorized' }
AIAbstractMCPServer class >> reset [

	RegisteredServers := nil.
	self changed: #registeredServers.
]

{ #category : 'Not categorized' }
AIAbstractMCPServer class >> unregisterServer: server [

	self registeredServers remove: server.
	self changed: #registeredServers.
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> call: methodName with: methodArguments [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> functions [

	^ (self tools collect: [ :tool | AIMCPServerToolFunction server: self toolName: (tool at: 'name') ])
		select: [ :function | ([ function parameters ] when: ExError do: [ :error | error exitWith: nil ]) notNil ]
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> initializeArguments [

	^ EsOrderedDictionary
		with: 'protocolVersion' -> '2025-11-25'
		with: 'capabilities' -> EsOrderedDictionary new
		with: 'clientInfo' -> (EsOrderedDictionary with: 'name' -> AIChat name asString with: 'version' -> '1.0')
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> initializeWithName: initialName [

	self initialize.
	name := initialName.
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> jsonRPCObjectCalling: methodName id: id with: methodArguments [

	| jsonRPCObject |

	jsonRPCObject := EsOrderedDictionary with: 'jsonrpc' -> '2.0'.
	id ifNotNil: [
		jsonRPCObject add: 'id' -> id ].
	jsonRPCObject add: 'method' -> methodName.
	methodArguments ifNotNil: [
		jsonRPCObject add: 'params' -> methodArguments ].
	^ jsonRPCObject
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> name [

	^ name
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> name: newName [

	name := newName.
	self changed: #name.
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> resetTools [

	tools := nil
]

{ #category : 'Not categorized' }
AIAbstractMCPServer >> tools [

	^ tools ifNil: [ tools := (self call: 'tools/list' with: EsOrderedDictionary new) at: 'tools' ]
]
