Class {
	#name : 'GeminiFunctionFindSenders',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> applyFunctionTo: arguments in: context [

	| selectorStrings includeSource methods maxResults |

	selectorStrings := arguments at: 'selectors'.
	includeSource := (arguments at: 'with_source').
	maxResults := self resultLimitFor: context withSource: includeSource.
	methods := OrderedCollection new.

	(self
		classesScopedTo: (arguments at: 'applications' ifAbsent: [#()])
		and: (arguments at: 'classes' ifAbsent: [#()]))
			do: [:class |
				class methodsDo: [:method | | methodSendsOneOfThem |
					methodSendsOneOfThem :=
						method symbolLiterals anySatisfy: [:literalSelector |
							selectorStrings
								anySatisfy: [:selectorString | selectorString match: literalSelector]].
					methodSendsOneOfThem
						ifTrue: [
							methods add: (
								includeSource
									ifTrue: [method geminiJSON]
									ifFalse: [method geminiJSONWithoutSource]).
							methods size >= maxResults
								ifTrue: [
									^EsOrderedDictionary
										with: 'methods' -> methods
										with:
											'warning' -> (
												'Results exceeded maximum limit of %1. Please retry with a more restricted scope or use another function.'
													bindWith: maxResults)]]]].

	^EsOrderedDictionary with: 'methods' -> methods
]

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> description [

	^ 'Finds all methods that send/call the given selector/method.'
]

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> name [

	^ 'find_senders'
]

{ #category : 'Not categorized' }
GeminiFunctionFindSenders >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'selectors'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'The selectors of methods to find senders of. Case insensitive, can contain wildcards like * (e.g., backgroundCo*, *textWid*)'. 
		GeminiFunctionParameterRequired name: 'with_source'
			type: GeminiFunctionParameterTypeBoolean new
			description: 'Include full source of implementors. Prefer false unless relevant' .
		GeminiFunctionParameterOptional name: 'classes'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Scope search to provided classes. Use if possible'.
		GeminiFunctionParameterOptional name: 'applications'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Scope search to provided applications. Use if possible'.
		}
]
