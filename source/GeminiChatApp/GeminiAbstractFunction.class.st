Class {
	#name : 'GeminiAbstractFunction',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiAbstractFunction >> applicationNamed: applicationName [

	| applicationNameSymbol |

	applicationNameSymbol := applicationName asSymbol.
	^ System loadedSubApplications detect: [ :application | application name = applicationNameSymbol ] ifNone: [ nil ]
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> applyFunctionTo: arguments in: context [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> applyTo: arguments in: functionCallContext [

	| parameters |

	parameters := self parameters.
	arguments keysDo: [ :key |
		(parameters anySatisfy: [ :parameter | key = parameter name ]) ifFalse: [
			^ EsOrderedDictionary with: 'error' -> ('The function does not have a parameter "%1"' bindWith: key) ] ].
	parameters do: [ :parameter |
		(parameter isRequired not or: [ arguments includesKey: parameter name ]) ifFalse: [
			^ EsOrderedDictionary with: 'error' -> ('No argument given for required parameter "%1"' bindWith: parameter name) ] ].
	^ self applyFunctionTo: arguments in: functionCallContext
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> classesInApplicationNamed: applicationName [

	^ (self applicationNamed: applicationName) ifNotNil: [ :application | application defined ]
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> classNamed: className [

	^ Smalltalk classAt: className
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> description [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> functionDeclarationJSON [

	^ EsOrderedDictionary
		with: 'name' -> self name
		with: 'description' -> self description
		with: 'parameters' -> self parametersSchemaJSON
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> name [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> parameters [

	self subclassResponsibility
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> parametersSchemaJSON [

	| properties required |

	properties := EsOrderedDictionary new.
	required := OrderedCollection new.
	self parameters do: [ :parameter |
		properties at: parameter name put: parameter typeSchemaJSON.
		parameter isRequired ifTrue: [
			required add: parameter name ] ].
	^ EsOrderedDictionary
		with: 'type' -> 'object'
		with: 'properties' -> properties
		with: 'required' -> required
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> regexMatcherForArgumentsIn: functionArguments onSyntaxError: errorBlock [

	^ [ GeminiRegexMatcher forRegex: (functionArguments at: 'regex') ignoreCase: (functionArguments at: 'ignore_case' ifAbsent: [ false ]) ] on: RegexSyntaxError
		do: [ :error | errorBlock value: (EsOrderedDictionary with: 'error' -> ('Syntax error in regular expression at position %1: %2' bindWith: error position with: error messageText)) ]
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> response: resultKey collect: block forClassesNamed: classNames [

	| resultPerClass classesNotFound |

	resultPerClass := EsOrderedDictionary new.
	classesNotFound := OrderedCollection new.

	classNames do: [ :className |
		(self classNamed: className)
			ifNotNil: [ :class | resultPerClass at: className put: (block value: class) ]
			ifNil: [ classesNotFound add: className ] ].

	^ EsOrderedDictionary
		with: resultKey -> resultPerClass
		with: 'nonexistent_or_outside_scope_classes' -> classesNotFound
]

{ #category : 'Not categorized' }
GeminiAbstractFunction >> withLineStreamWithRewindLimit: rewindLimit forFileIn: functionArguments in: functionCallContext do: block [

	| fileNumber filePath startPosition |

	fileNumber := functionArguments at: 'file_number'.
	filePath := functionCallContext filePaths at: fileNumber ifAbsent: [
		^ EsOrderedDictionary with: 'error' -> ('There is no file numbered %1' bindWith: fileNumber) ].
	startPosition := (functionArguments at: 'start' ifAbsent: [ 1 ]) - 1.
	filePath readStreamDo: [ :fileStream |
		| lineStream |
		(lineStream := GeminiRewindableStream on: (GeminiLineStream on: fileStream) rewindLimit: rewindLimit)
			position: startPosition.
		^ block value: lineStream ].
	^ EsOrderedDictionary with: 'error' -> 'The file could not be opened, it may have been removed'
]
