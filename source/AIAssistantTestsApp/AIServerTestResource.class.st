Class {
	#name : 'AIServerTestResource',
	#superclass : 'TestResource',
	#instVars : [
		'server',
		'responseObjectsSequenceGeminiAPI',
		'responseObjectsSequenceResponsesAPI'
	],
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIServerTestResource >> responseObjectsGeminiAPI: newResponseObjects [

	self responseObjectsSequenceGeminiAPI: { newResponseObjects }
]

{ #category : 'Not categorized' }
AIServerTestResource >> responseObjectsResponsesAPI: newResponseObjects [

	self responseObjectsSequenceResponsesAPI: { newResponseObjects }
]

{ #category : 'Not categorized' }
AIServerTestResource >> responseObjectsSequenceGeminiAPI: newResponseObjectsSequence [

	responseObjectsSequenceGeminiAPI := OrderedCollection withAll: newResponseObjectsSequence
]

{ #category : 'Not categorized' }
AIServerTestResource >> responseObjectsSequenceResponsesAPI: newResponseObjectsSequence [

	responseObjectsSequenceResponsesAPI := OrderedCollection withAll: newResponseObjectsSequence
]

{ #category : 'Not categorized' }
AIServerTestResource >> setUp [

	| handler invocationHandlerOrError serverOrError |

	super setUp.
	responseObjectsSequenceGeminiAPI := OrderedCollection new.
	responseObjectsSequenceResponsesAPI := OrderedCollection new.
	handler := DirectedMessage
		receiver: [ :request :response |
			| responseContents |
			responseContents := ''.
			(request header url includesSubstring: 'MockGeminiAPI') ifTrue: [
				responseContents := NeoJSONWriter toString: responseObjectsSequenceGeminiAPI removeFirst ].
			(request header url includesSubstring: 'MockResponsesAPI') ifTrue: [
				responseContents := String streamContents: [ :stream |
					responseObjectsSequenceResponsesAPI removeFirst do: [ :responseObject |
						stream nextPutAll: 'data: '; nextPutAll: (NeoJSONWriter toString: responseObject);
							nextPutAll: String crlf; nextPutAll: String crlf ] ] ].
			response
				header: ((SstHttpResponseHeader status: SstHttpConstants::HttpOk)
					version: SstHttpConstants::HttpVersion11;
					yourself);
				contents: responseContents asUtf8Bytes;
				yourself ]
		selector: #value:value:.
	server := SstBasicServer new.
	(invocationHandlerOrError := server addHandlerUrl: 'http://:9988') isSstError 
		ifTrue: [ invocationHandlerOrError raise ].
	server requestHandler: handler.
	(serverOrError := server startUp) isSstError
		ifTrue: [ serverOrError raise ].
]

{ #category : 'Not categorized' }
AIServerTestResource >> tearDown [

	server ifNotNil: [
		server shutDown ].
	super tearDown.
]
