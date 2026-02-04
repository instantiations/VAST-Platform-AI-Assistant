Class {
	#name : 'GeminiFunctionFindSenders',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> applyFunctionTo: arguments in: context [

	| selector methods |

	selector := (arguments at: 'selector') asSymbol.
	methods := OrderedCollection new.

	System allClasses do: [ :class |
		{ class. class class } do: [ :methodClass |
			(methodClass whichMethodsSend: selector) do: [ :method |
				methods add: method geminiJSON ] ] ].

	^ EsOrderedDictionary with: 'methods' -> methods
]

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> description [

	^ 'Finds all methods that send the given selector.'
]

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> name [

	^ 'find_senders'
]

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'selector'
			type: GeminiFunctionParameterTypeString new
			description: 'The selector to find senders for' }
]
