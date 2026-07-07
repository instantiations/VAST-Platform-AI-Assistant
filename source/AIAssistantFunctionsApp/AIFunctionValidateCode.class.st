Class {
	#name : 'AIFunctionValidateCode',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionValidateCode >> applyFunctionTo: arguments in: context [

	| code |

	code := arguments at: 'code'.
	^ (self isMethodCode: code)
		ifTrue: [ self validate: code from: (code indexOf: $>) + 2 forEvaluation: false context: context ]
		ifFalse: [ self validate: code from: 1 forEvaluation: true context: context ]
]

{ #category : 'Accessing' }
AIFunctionValidateCode >> category [

	^ 'Testing & Debugging'
]

{ #category : 'Not categorized' }
AIFunctionValidateCode >> description [

	^ 'Validates syntax and checks for sent selectors with no known implementors.'
]

{ #category : 'Not categorized' }
AIFunctionValidateCode >> isMethodCode: aString [

	| line |
	aString isEmpty ifTrue: [^nil].
	line := aString lines first.
	^self methodMatcher matches: line
]

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIFunctionValidateCode >> methodMatcher [

	^'^(\w+)\s*(class)?\s*>>\s*(.+)$' asRegex
]

{ #category : 'Not categorized' }
AIFunctionValidateCode >> name [

	^ 'validate_code'
]

{ #category : 'Not categorized' }
AIFunctionValidateCode >> parameters [

	^ {
		AIFunctionParameterRequired name: 'code'
			type: AIFunctionParameterTypeString new
			description: 'The VAST Smalltalk code' }
]
