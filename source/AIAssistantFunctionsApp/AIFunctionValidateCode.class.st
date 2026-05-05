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
		ifTrue: [ self validate: code from: (code indexOf: $>) + 2 forEvaluation: false ]
		ifFalse: [ self validate: code from: 1 forEvaluation: true ]
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

{ #category : 'Not categorized' }
AIFunctionValidateCode >> validate: code from: startIndex forEvaluation: forEvaluation [

	| selectors methodParseNode previousPropertyValue mainResult |

	methodParseNode :=
		AISmalltalkParser
			parse: (code copyFrom: startIndex to: code size)
			messagePattern: forEvaluation not
			scanComments: true
			onError: [:errorString :sourcePosition |
				^EsOrderedDictionary with:
					'error' -> (
						'Syntax error in given code at position %1: %2'
							bindWith: (sourcePosition + startIndex - 1) asString
							with: errorString)].
	selectors := methodParseNode messagesSent reject: [:selector |
		StsPowerTools methodSelectorExistsInSystem: selector].
	selectors ifNotEmpty:[
		^EsOrderedDictionary with:
			'error' -> (
				'Sends selectors that have no implementors: ' ,
					((selectors sorted collect: [:selector | selector printString]) joinUsing: ', '))].
	^EsOrderedDictionary with: 'valid' -> true
]
