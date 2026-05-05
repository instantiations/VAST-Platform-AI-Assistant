Class {
	#name : 'AIFunctionFindSenders',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionFindSenders >> applyFunctionTo: arguments in: context [

	| selectorStrings includeSource matchCase methods maxResults selectorPatternMatchers |

	selectorStrings := arguments at: 'selectors'.
	includeSource := arguments at: 'with_source'.
	matchCase := arguments at: 'match_casing' ifAbsent: [true].
	maxResults := self resultLimitFor: context withSource: includeSource.
	methods := OrderedCollection new.
	selectorPatternMatchers :=selectorStrings collect: [ :pattern | AISelectorPatternMatcher forPattern: pattern ignoreCase: matchCase not ].
	(self
		classesScopedTo: (arguments at: 'applications' ifAbsent: [#()])
		and: (arguments at: 'classes' ifAbsent: [#()]))
			do: [:class |
				class methodsDo: [:method |
					(selectorPatternMatchers anySatisfy: [ :selectorPatternMatcher | selectorPatternMatcher matchesAnySendsInMethod: method ])
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
AIFunctionFindSenders >> description [

	^ 'Finds all methods that send/call the given selector/method.'
]

{ #category : 'Not categorized' }
AIFunctionFindSenders >> name [

	^ 'find_senders'
]

{ #category : 'Not categorized' }
AIFunctionFindSenders >> parameters [

	^ {
		AIFunctionParameterRequired name: 'selectors'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'The selectors of a message send to find senders of / references to. Can contain wildcards - * matches any sequence, # matches one character (browseMessage*, symbol#iterals)'. 
		AIFunctionParameterRequired name: 'with_source'
			type: AIFunctionParameterTypeBoolean new
			description: 'Include full source of implementors. Prefer false unless relevant'.
		AIFunctionParameterOptional name: 'match_casing'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeBoolean new)
			description: 'Results must match parameter casing. True by default'.
		AIFunctionParameterOptional name: 'classes'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Scope search to provided classes. Use if possible'.
		AIFunctionParameterOptional name: 'applications'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Scope search to provided applications. Use if possible'.
		}
]
