Class {
	#name : 'AIMCPServerStreamableHTTP',
	#superclass : 'AIAbstractMCPServer',
	#instVars : [
		'url',
		'sessionID'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP class >> label [

	^ 'Streamable HTTP'
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP class >> name: serverName [

	^ self name: serverName url: nil
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP class >> name: serverName url: url [

	^ self basicNew initializeWithName: serverName url: url
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP class >> name: serverName urlString: urlString [

	^ self name: serverName url: (SstUrl fromString: urlString)
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP >> call: methodName id: id with: methodArguments do: block [

	| httpClient |

	httpClient := SstHttpClient forTransportScheme: self url localEndpointUrl transport.
	^ [
		| headers responseOrError |
		headers := EsOrderedDictionary with: 'Host' -> 'localhost' with: 'Accept' -> 'application/json, text/event-stream'.
		sessionID ifNotNil: [
			headers add: 'MCP-Session-ID' -> sessionID ].
		responseOrError := httpClient post: (AIJSONWriter toString: (self jsonRPCObjectCalling: methodName id: id with: methodArguments)) asUtf8Bytes
			typed: 'application/json' at: self url using: nil withHeaders: headers.
		responseOrError isSstError ifTrue: [
			responseOrError raise ].
		block
			cull: (id ifNotNil: [
				| characterStream |
				characterStream := AIPeekableStream on: (AICharacterGraphemeStream on: (AIUTF8DecodingStream on: responseOrError contents asByteArray readStream)).
				(responseOrError header contentType = 'application/json'
					ifTrue: [ (AIJSONReader on: characterStream) next ]
					ifFalse: [
						| serverSentEventsStream json |
						serverSentEventsStream := AIPeekableStream on: (AIServerSentEventsStream on: characterStream).
						serverSentEventsStream peek data ifEmpty: [
							serverSentEventsStream next ].
						json := AIJSONReader fromString: serverSentEventsStream next data.
						serverSentEventsStream atEnd ifFalse: [
							Error signal: 'Server-sent events stream unexpectedly not at end' ].
						json ])
					at: 'result' ])
			cull: responseOrError header
	] ensure: [ httpClient shutDown ]
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP >> call: methodName with: methodArguments [

	| retried |

	retried := false.
	^ [ self call: methodName id: UUID new asString with: methodArguments do: [ :result | result ] ]
		when: ExError do: [ :error |
			retried ifFalse: [
				sessionID := nil.
				sessionID := self call: 'initialize' id: UUID new asString with: self initializeArguments do: [ :result :header | header at: 'MCP-Session-ID' ].
				self call: 'notifications/initialized' id: nil with: nil do: [ ].
				retried := true.
				error retry
			] ifTrue: [
				error pass ] ]
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP >> initializeWithName: initialName url: initialURL [

	self initializeWithName: initialName.
	url := initialURL.
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP >> isStreamableHTTP [

	^ true
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP >> url [

	^ url
]

{ #category : 'Not categorized' }
AIMCPServerStreamableHTTP >> url: newUrl [

	url := newUrl.
	self changed: #url.
]
