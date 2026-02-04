Class {
	#name : 'GeminiFunctionFindMethodsWithLinesMatchingRegex',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionFindMethodsWithLinesMatchingRegex >> applyFunctionTo: arguments in: context [

	^ EsOrderedDictionary with: 'methods' ->
		((self findAtMost: 50 methodsWithAnyLineMatching: (self regexMatcherForArgumentsIn: arguments onSyntaxError: [ :error | ^ error ]))
			collect: [ :method | method geminiJSON ])
]

{ #category : 'Not categorized' }
GeminiFunctionFindMethodsWithLinesMatchingRegex >> description [

	^ 'Finds methods whose entire source (including comments) matches the given regular expression. At most 50 methods will be returned.'
]

{ #category : 'Not categorized' }
GeminiFunctionFindMethodsWithLinesMatchingRegex >> findAtMost: maxNumber methodsWithAnyLineMatching: regexMatcher [

	| methods |

	methods := OrderedCollection new.
	System allClasses do: [ :class |
		{ class. class class } do: [ :methodClass |
			methodClass methodsDo: [ :method |
				(regexMatcher matchesAnyLineIn: method sourceString) ifTrue: [
					methods add: method.
					methods size = maxNumber ifTrue: [ ^ methods ] ] ] ] ].
	^ methods
]

{ #category : 'Not categorized' }
GeminiFunctionFindMethodsWithLinesMatchingRegex >> name [

	^ 'find_methods_with_lines_matching_regex'
]

{ #category : 'Not categorized' }
GeminiFunctionFindMethodsWithLinesMatchingRegex >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'regex'
			type: GeminiFunctionParameterTypeString new
			description: ('The regular expression to match lines against, using the syntax defined by the class RxMatcher in VAST, ' ,
				'colons have special meaning and need to be escaped to match literally').
		GeminiFunctionParameterOptional name: 'ignore_case'
			type: GeminiFunctionParameterTypeBoolean new
			description: 'Whether to match the regular expression case-insensitivly or not, defaults to false' }
]
