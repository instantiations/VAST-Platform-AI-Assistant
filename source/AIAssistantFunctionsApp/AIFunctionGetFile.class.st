Class {
	#name : 'AIFunctionGetFile',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionGetFile >> applyFunctionTo: arguments in: context [

	| maxSizeLines |

	maxSizeLines := arguments at: 'max' ifAbsent: [ 100 ].
	^ self withLineStreamWithRewindLimit: 0 forFileIn: arguments in: context do: [:lineStream | 
		| lines stopPosition |
		lines := OrderedCollection new: maxSizeLines.
		stopPosition := lineStream position + maxSizeLines.
		[ lineStream atEnd not and: [ lineStream position < stopPosition ] ] whileTrue: [
			lines add: lineStream next ].
		EsOrderedDictionary with: 'lines' -> lines with: 'line_count' -> lines size ]
]

{ #category : 'Not categorized' }
AIFunctionGetFile >> description [

	^ 'Retrieves content using the `file_number` index returned by the `list_files` tool.'
]

{ #category : 'Not categorized' }
AIFunctionGetFile >> name [

	^ 'get_file'
]

{ #category : 'Not categorized' }
AIFunctionGetFile >> parameters [

	^ {
		AIFunctionParameterRequired name: 'file_number'
			type: AIFunctionParameterTypeInteger new
			description: 'The number of the file'.
		AIFunctionParameterOptional name: 'start'
			type: AIFunctionParameterTypeInteger new
			description: 'The line number of the first line to get, defaults to 1'.
		AIFunctionParameterOptional name: 'max'
			type: AIFunctionParameterTypeInteger new
			description: 'The maximum number of lines to get, defaults to 100' }
]
