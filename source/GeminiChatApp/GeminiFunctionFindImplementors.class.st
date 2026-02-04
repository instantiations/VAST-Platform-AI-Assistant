Class {
	#name : 'GeminiFunctionFindImplementors',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> applyFunctionTo: arguments in: context [

	| selector methods |

	selector := (arguments at: 'selector') asSymbol.
	methods := OrderedCollection new.

	System allClasses do: [ :class |
		{ class. class class } do: [ :methodClass |
			(methodClass includesSelector: selector)
				ifTrue: [ methods add: (methodClass compiledMethodAt: selector) geminiJSON ] ] ].

	^ EsOrderedDictionary with: 'methods' -> methods
]

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> description [

	^ 'Finds all methods that implement the given selector.'
]

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> name [

	^ 'find_implementors'
]

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'selector'
			type: GeminiFunctionParameterTypeString new
			description: 'The selector to find implementors for' }
]
