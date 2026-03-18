Class {
	#name : 'GeminiFunctionHelp',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionHelp >> applyFunctionTo: arguments in: context [

	^ EsOrderedDictionary with: 'overview' -> 
'A Smalltalk environment is a live, editable program. 
It does NOT store its source in files, so NEVER use file related tools when exploring code.
Instead, you navigate by exploring the environment using the provided tools.
For names received in user input, always do a describe tool call before you use other tools to investigate - this sanitizes the input, and gives some basic metadata which is needed for further efficient tool use.
Expect multiple tool uses will be needed to reach an answer - use parameters to specify the smallest scope whenever possible. Prefer using tools to return only relevant results to the current area of investigation
Setter/getters in Smalltalk are usually without set/get prefix, for instance instead of getValue / setValue: , the accessors will usually be value / value:'
]

{ #category : 'Not categorized' }
GeminiFunctionHelp >> description [

	^ 'This tool describes how to efficiently use tools to explore the VAST Smalltalk environment'
]

{ #category : 'Not categorized' }
GeminiFunctionHelp >> name [

	^ 'help'
]

{ #category : 'Not categorized' }
GeminiFunctionHelp >> parameters [

	^ {
"		GeminiFunctionParameterOptional name: 'area'
			type: GeminiFunctionParameterTypeString new
			description: 'If you need help on a specific topic'." 
		}
]
