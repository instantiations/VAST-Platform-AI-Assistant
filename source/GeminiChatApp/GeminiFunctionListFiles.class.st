Class {
	#name : 'GeminiFunctionListFiles',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionListFiles >> applyFunctionTo: arguments in: context [

	| files |

	files := OrderedCollection new.
	context filePaths doWithIndex: [ :filePath :index |
		files add: (EsOrderedDictionary with: 'file_number' -> index with: 'name' -> filePath fileName) ].
	^ EsOrderedDictionary with: 'files' -> files
]

{ #category : 'Not categorized' }
GeminiFunctionListFiles >> description [

	^ 'Lists files provided by the user.'
]

{ #category : 'Not categorized' }
GeminiFunctionListFiles >> name [

	^ 'list_files'
]

{ #category : 'Not categorized' }
GeminiFunctionListFiles >> parameters [

	^ { }
]
