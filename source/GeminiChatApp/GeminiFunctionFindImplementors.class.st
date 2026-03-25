Class {
	#name : 'GeminiFunctionFindImplementors',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> applyFunctionTo: arguments in: context [

	| selectors includeSource matchCasing methods maxResults selectorPatternMatchers |

	selectors := (arguments at: 'selectors') collect: [:each | each asSymbol].
	includeSource := arguments at: 'with_source'.
	matchCasing := arguments at: 'match_casing' ifAbsent: [true].
	maxResults := self resultLimitFor: context withSource: includeSource.
	methods := OrderedCollection new.
	
	selectorPatternMatchers := selectors collect: [ :pattern | GeminiSelectorPatternMatcher forPattern: pattern ignoreCase: matchCasing not ].

	(self
		classesScopedTo: (arguments at: 'applications' ifAbsent: [#()])
		and: (arguments at: 'classes' ifAbsent: [#()]))
			do: [:class |
				{ class. class class } do: [:methodClass |
					selectorPatternMatchers do: [ :selectorPatternMatcher |
						(selectorPatternMatcher matchingSelectorsInClass: methodClass)
							do: [ :foundSelector |
								| cm |
								cm := (methodClass compiledMethodAt: foundSelector).
								methods add: (
									includeSource
										ifTrue: [cm geminiJSON]
										ifFalse: [cm geminiJSONWithoutSource]).
								methods size >= maxResults
									ifTrue: [
										^EsOrderedDictionary
											with: 'methods' -> methods
											with:
												'warning' -> (
													'Results exceeded maximum limit of %1. Please retry with a more restricted scope or use another function.'
														bindWith: maxResults)]]]]].

	^EsOrderedDictionary with: 'methods' -> methods
]

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> description [

	^ 'Find methods that implement the given selector.'
]

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> name [

	^ 'find_implementors'
]

{ #category : 'Not categorized' }
GeminiFunctionFindImplementors >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'selectors'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'An array containing the selectors of methods to find implementors / definitions of. Can contain wildcards - * matches any sequence, # matches one character (browseMessage*, symbol#iterals)'.
		GeminiFunctionParameterRequired name: 'with_source'
			type: GeminiFunctionParameterTypeBoolean new
			description: 'Include full source of implementors. Prefer false unless relevant' .
		GeminiFunctionParameterOptional name: 'match_casing'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeBoolean new)
			description: 'Results must match parameter casing. True by default'.
		GeminiFunctionParameterOptional name: 'classes'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Scope search to provided classes. Use if possible'.
		GeminiFunctionParameterOptional name: 'applications'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Scope search to provided applications. Use if possible'.}
]
