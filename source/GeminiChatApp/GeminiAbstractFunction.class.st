Class {
	#name : 'GeminiAbstractFunction',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'System Search',
  #vaVisibility : 'private' }
GeminiAbstractFunction >> applicationNamed: applicationName [

	| applicationNameSymbol |

	applicationNameSymbol := applicationName asSymbol.
	^System loadedSubApplications
		detect: [:application | application name = applicationNameSymbol]
		ifNone: [nil]
]

{ #category : 'Actions',
 #vaCategories : ['API','Actions'] }
GeminiAbstractFunction >> applyFunctionTo: arguments in: context [

	self subclassResponsibility
]

{ #category : 'Actions',
 #vaCategories : ['API','Actions'] }
GeminiAbstractFunction >> applyTo: arguments in: functionCallContext [

	| parameters |

	parameters := self parameters.
	arguments keysAndValuesDo: [ :parameterName :argument |
		| parameter |
		parameter := parameters detect: [ :someParameter | someParameter name = parameterName ] ifNone: [
			^ EsOrderedDictionary with: 'error' -> ('The function does not have a parameter "%1"' bindWith: parameterName) ].
		(parameter validateArgument: argument) ifFalse: [
			^ EsOrderedDictionary with: 'error' -> ('Invalid argument given for parameter "%1"' bindWith: parameterName) ] ].
	parameters do: [ :parameter |
		(parameter isRequired not or: [ arguments includesKey: parameter name ]) ifFalse: [
			^ EsOrderedDictionary with: 'error' -> ('No argument given for required parameter "%1"' bindWith: parameter name) ] ].
	^ self applyFunctionTo: arguments in: functionCallContext
]

{ #category : 'System Search',
  #vaVisibility : 'private' }
GeminiAbstractFunction >> classNamed: className [

	^ className asEsString ifNotNil: [ :esString | Smalltalk classAt: esString ]
]

{ #category : 'System Search',
  #vaVisibility : 'private' }
GeminiAbstractFunction >> classesInApplicationNamed: applicationName [
	"Return classes that are defined / extended in a provided applicationName"

	^(self applicationNamed: applicationName)
		ifNil: [#()]
		ifNotNil: [:application | application allLocalClasses]
]

{ #category : 'System Search',
  #vaVisibility : 'private' }
GeminiAbstractFunction >> classesScopedTo: applicationNames and: classNames [
	"Return classes that are either
	 - defined / extended in a provided applicationName
	 - a class with a provided className"

	| classesToSearch |

	classesToSearch :=
		((classNames collect: [:className | self classNamed: className])
			select: [:class | class notNil])
				asSet.
	applicationNames
		do: [:appName | classesToSearch addAll: (self classesInApplicationNamed: appName)].
	classesToSearch isEmpty ifTrue: [classesToSearch := System allClasses].
	^classesToSearch
]

{ #category : 'Accessing',
 #vaCategories : ['API','Accessing'] }
GeminiAbstractFunction >> description [

	self subclassResponsibility
]

{ #category : 'Accessing' }
GeminiAbstractFunction >> functionDeclarationJSON [

	^ EsOrderedDictionary
		with: 'name' -> self name
		with: 'description' -> self description
		with: 'parameters' -> self parametersSchemaJSON
]

{ #category : 'Accessing',
 #vaCategories : ['API','Accessing'] }
GeminiAbstractFunction >> name [

	self subclassResponsibility
]

{ #category : 'Accessing',
 #vaCategories : ['API','Accessing'] }
GeminiAbstractFunction >> parameters [

	self subclassResponsibility
]

{ #category : 'Accessing' }
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

{ #category : 'System Search',
  #vaVisibility : 'private' }
GeminiAbstractFunction >> regexMatcherForArgumentsIn: functionArguments onSyntaxError: errorBlock [

	^ [ GeminiRegexMatcher forRegex: (functionArguments at: 'regex') ignoreCase: (functionArguments at: 'ignore_case' ifAbsent: [ false ]) ] on: RegexSyntaxError
		do: [ :error | errorBlock value: (EsOrderedDictionary with: 'error' -> ('Syntax error in regular expression at position %1: %2' bindWith: error position with: error messageText)) ]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
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

{ #category : 'Internal',
  #vaVisibility : 'private' }
GeminiAbstractFunction >> resultLimitFor: aContext [
	"Limit max results to an appropriate size for the maximum context size"

	aContext isNil
		ifFalse: [
			aContext model contextWindowSize ifNotNil: [:contextSize |
				"Allow 200 results per call for a 200K token context size"
				^contextSize // 1000]].
	"Unknown context size, conservative default"
	^200
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
GeminiAbstractFunction >> resultLimitFor: aContext withSource: includeSource [

	| resultLimit |

	resultLimit := self resultLimitFor: aContext.
	"Allow less results when returning full source"
	includeSource ifTrue: [resultLimit := (resultLimit // 4) ].
	^resultLimit
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
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
