Class {
	#name : 'AIAbstractStackIterationFunction',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Testing' }
AIAbstractStackIterationFunction class >> isAbstract [

	^ self == AIAbstractStackIterationFunction
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractStackIterationFunction >> defaultStackSizeLimit [

	^ DbgDebugSession defaultStackSizeLimit min: 500
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractStackIterationFunction >> maxStackSizeLimit [

	^ 1000
]

{ #category : 'Accessing' }
AIAbstractStackIterationFunction >> parameters [

	^{
	AIFunctionParameterOptional
			name: 'stacksize_limit'
			type: AIFunctionParameterTypeInteger new
			description: ('The maximum number of frames, defaults to %1 and maxes out at %2.' bindWith: self defaultStackSizeLimit asString with: self maxStackSizeLimit asString).
		AIFunctionParameterOptional
			name: 'printstring_limit'
			type: AIFunctionParameterTypeInteger new
			description: ('The limit to use for the print string of any value contained in the stack frame after which it gets truncated, defaults to %1 and maxes out at %2' bindWith: self defaultPrintStringLimit asString with: self maxPrintStringLimit asString) }
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractStackIterationFunction >> stackFramesJSONFrom: firstFrame arguments: arguments inContext: context [

	^ self
		stackFramesJSONFrom: firstFrame
		arguments: arguments
		inContext: context
		until: [:frame | false]
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIAbstractStackIterationFunction >> stackFramesJSONFrom: firstFrame arguments: arguments inContext: context until: endBlock [

	| stringlimit stacklimit frames allFrames |

	firstFrame ifNil: [^#()].
	stringlimit := self printStringLimitFrom: arguments.
	stacklimit := (arguments at: 'stacksize_limit' ifAbsent: [self defaultStackSizeLimit]) min: self maxStackSizeLimit.
	
	allFrames := OrderedCollection with: firstFrame.
	allFrames addAll: (firstFrame previousFrames: stacklimit - 1).
	
	frames := OrderedCollection new: allFrames size.
	allFrames do: [:frame |
		frames add: (frame aiJSONInContext: context stringsLimitedTo: stringlimit indexedLimitedTo: self defaultIndexedLimit).
		(endBlock value: frame) ifTrue: [^frames]].
	
	^ frames
]
