Class {
	#name : 'GeminiFunctionGetUrl',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetUrl >> applyFunctionTo: arguments in: context [

	| url httpClient |

	url := (arguments at: 'url') asSBString ifNotNil: [ :urlString | urlString sstAsUrl ].
	(url notNil and: [ #('http' 'https') includes: url scheme ]) ifFalse: [
		^ EsOrderedDictionary with: 'error' -> 'The "url" argument is not a valid URL with scheme "http" or "https"' ].
	(httpClient := SstHttpClient forTransportScheme: url localEndpointUrl transport)
		proxyEnabled: true.
	[
		| responseOrError |
		responseOrError := httpClient get: url using: nil withHeaders: (EsOrderedDictionary
			with: SstHttpConstants::HttpAcceptCharsetKey -> 'utf-8'
			with: SstHttpConstants::HttpUserAgentKey -> httpClient class name).
		^ responseOrError isSstError
			ifFalse: [
				| contentsByteArray contentsString |
				contentsByteArray := responseOrError contents asByteArray.
				contentsString := [ UnicodeString utf8: contentsByteArray ] when: ExError do: [ :error | error exitWith: contentsByteArray asString ].
				EsOrderedDictionary with: 'pagecontents' -> contentsString ]
			ifTrue: [
				((responseOrError errorCode = SstErrorConstants::SstReceiveError) and: [ responseOrError errorObject sstIsMessage])
					ifTrue: [ EsOrderedDictionary with: 'error' -> ('The server responded with HTTP status code %1' bindWith: responseOrError errorObject header statusCode) ]
					ifFalse: [ EsOrderedDictionary with: 'error' -> 'Sending the request to the server failed' ] ]
	] ensure: [
		httpClient shutDown ]
]

{ #category : 'Not categorized' }
GeminiFunctionGetUrl >> description [

	^ 'Retrieves the content that is served at the `url`.'
]

{ #category : 'Not categorized' }
GeminiFunctionGetUrl >> name [

	^ 'get_url'
]

{ #category : 'Not categorized' }
GeminiFunctionGetUrl >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'url'
			type: GeminiFunctionParameterTypeString new
			description: 'The url'. 
		}
]
