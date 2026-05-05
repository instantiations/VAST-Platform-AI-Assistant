Class {
	#name : 'AIFunctionListFiles',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionListFiles >> applyFunctionTo: arguments in: context [

	| files |

	files := OrderedCollection new.
	context filePaths doWithIndex: [ :filePath :index |
		files add: (EsOrderedDictionary with: 'file_number' -> index with: 'name' -> filePath fileName) ].
	^ EsOrderedDictionary with: 'files' -> files
]

{ #category : 'Not categorized' }
AIFunctionListFiles >> description [

	^ 'Lists files provided by the user.'
]

{ #category : 'Not categorized' }
AIFunctionListFiles >> name [

	^ 'list_files'
]

{ #category : 'Not categorized' }
AIFunctionListFiles >> parameters [

	^ { }
]
