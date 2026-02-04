Class {
	#name : 'GeminiFunctionGetFile',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetFile >> applyFunctionTo: arguments in: context [

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
GeminiFunctionGetFile >> description [

	^ 'Retrieves content using the `file_number` index returned by the `list_files` tool.'
]

{ #category : 'Not categorized' }
GeminiFunctionGetFile >> name [

	^ 'get_file'
]

{ #category : 'Not categorized' }
GeminiFunctionGetFile >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'file_number'
			type: GeminiFunctionParameterTypeInteger new
			description: 'The number of the file'.
		GeminiFunctionParameterOptional name: 'start'
			type: GeminiFunctionParameterTypeInteger new
			description: 'The line number of the first line to get, defaults to 1'.
		GeminiFunctionParameterOptional name: 'max'
			type: GeminiFunctionParameterTypeInteger new
			description: 'The maximum number of lines to get, defaults to 100' }
]
