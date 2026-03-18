Class {
	#name : 'GeminiFunctionGetUrl',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetUrl >> applyFunctionTo: arguments in: context [

	| contents |
	contents := (arguments at: 'url') sstAsUrl fetch.
	^ EsOrderedDictionary with: 'pagecontents' -> contents
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
