Class {
	#name : 'AIFunctionFindLinesInFileMatchingRegex',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionFindLinesInFileMatchingRegex >> applyFunctionTo: arguments in: context [

	| matcher maxSizeMatches maxSizeLinesBefore maxSizeLinesAfter |

	matcher := self regexMatcherForArgumentsIn: arguments onSyntaxError: [ :error | ^ error ].
	maxSizeMatches := arguments at: 'max' ifAbsent: [ 10 ].
	maxSizeLinesBefore := arguments at: 'before' ifAbsent: [ 0 ].
	maxSizeLinesAfter := arguments at: 'after' ifAbsent: [ 0 ].
	^ self withLineStreamWithRewindLimit: (maxSizeLinesBefore + 1 + maxSizeLinesAfter) forFileIn: arguments in: context do: [ :lineStream |
		| matches |
		matches := OrderedCollection new.
		[ lineStream atEnd not and: [ matches size < maxSizeMatches ] ] whileTrue: [
			(matcher matchesLine: lineStream next) ifTrue: [
				| match |
				match := EsOrderedDictionary with: 'line_number' -> lineStream position.
				lineStream skip: -1.
				maxSizeLinesBefore > 0 ifTrue: [
					| sizeBefore linesBefore |
					sizeBefore := maxSizeLinesBefore min: lineStream position.
					lineStream skip: sizeBefore negated.
					match at: 'lines_before' put: (linesBefore := OrderedCollection new: sizeBefore).
					sizeBefore timesRepeat: [ linesBefore add: lineStream next ] ].
				match at: 'matching_line' put: lineStream next.
				maxSizeLinesAfter > 0 ifTrue: [
					| linesAfter |
					match at: 'lines_after' put: (linesAfter := OrderedCollection new: maxSizeLinesAfter).
					[ lineStream atEnd not and: [ linesAfter size < maxSizeLinesAfter ] ] whileTrue: [
						linesAfter add: lineStream next ].
					lineStream skip: linesAfter size negated ].
				matches add: match ] ].
		EsOrderedDictionary with: 'matches' -> matches ]
]

{ #category : 'Not categorized' }
AIFunctionFindLinesInFileMatchingRegex >> description [

	^ 'Finds lines in a file (that was provided by the user using list_files) matching a given regular expression. Do NOT use this tool for searching Smalltalk code that resides in the image, use find_senders or find_implementors instead.'
]

{ #category : 'Not categorized' }
AIFunctionFindLinesInFileMatchingRegex >> name [

	^ 'find_lines_in_file_matching_regex'
]

{ #category : 'Not categorized' }
AIFunctionFindLinesInFileMatchingRegex >> parameters [

	^ {
		AIFunctionParameterRequired name: 'file_number'
			type: AIFunctionParameterTypeInteger new
			description: 'The number of the file'.
		AIFunctionParameterRequired name: 'regex'
			type: AIFunctionParameterTypeString new
			description: ('The regular expression to match lines against, using the syntax defined by the class RxMatcher in VAST, ' ,
				'colons have special meaning and need to be escaped to match literally').
		AIFunctionParameterOptional name: 'ignore_case'
			type: AIFunctionParameterTypeBoolean new
			description: 'Whether to match the regular expression case-insensitivly or not, defaults to false'.
		AIFunctionParameterOptional name: 'start'
			type: AIFunctionParameterTypeInteger new
			description: 'The line number of the line to start matching at, defaults to 1'.
		AIFunctionParameterOptional name: 'max'
			type: AIFunctionParameterTypeInteger new
			description: 'The maximum number of matching lines to include, defaults to 10'.
		AIFunctionParameterOptional name: 'before'
			type: AIFunctionParameterTypeInteger new
			description: 'The number of lines of context before the matching line to include, defaults to 0'.
		AIFunctionParameterOptional name: 'after'
			type: AIFunctionParameterTypeInteger new
			description: 'The number of lines of context after the matching line to include, defaults to 0' }
]
