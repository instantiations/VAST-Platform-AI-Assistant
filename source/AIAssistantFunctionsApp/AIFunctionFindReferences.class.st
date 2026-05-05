Class {
	#name : 'AIFunctionFindReferences',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionFindReferences >> applyFunctionTo: arguments in: context [

	| variableName target includeSource methods maxResults |

	variableName := arguments at: 'variable_name'.

	"Resolve the variable name to an Association (for Globals/Classes) in Smalltalk"
	target := Smalltalk associationAt: variableName asSymbol ifAbsent: [nil].

	target ifNil: [
		^EsOrderedDictionary
			with: 'error' -> ('Variable %1 not found in Smalltalk' bindWith: variableName)].
	includeSource := (arguments at: 'with_source').
	maxResults := self resultLimitFor: context withSource: includeSource.

	methods := Set new.
	(self
		classesScopedTo: (arguments at: 'applications' ifAbsent: [#()])
		and: (arguments at: 'classes' ifAbsent: [#()]))
			do: [:class |
				"whichMethodsReferenceLiteral: checks both instance and class methods"
				(class whichMethodsReferenceLiteral: target) do: [:aCompiledMethod |
					methods add: aCompiledMethod.
					methods size >= maxResults
						ifTrue: [
							^EsOrderedDictionary
								with:
									'methods' -> (
										includeSource
											ifTrue: [methods collect: [:method | method geminiJSON]]
											ifFalse: [
												methods collect: [:method |
													method geminiJSONWithoutSource]])
								with:
									'warning' -> (
										'Results exceeded maximum limit of %1. Please retry with a more restricted scope or use another method.'
											bindWith: maxResults)]]].

	^EsOrderedDictionary with:
		'methods' -> (
			includeSource
				ifTrue: [methods collect: [:method | method geminiJSON]]
				ifFalse: [methods collect: [:method | method geminiJSONWithoutSource]])
]

{ #category : 'Not categorized' }
AIFunctionFindReferences >> description [

	^ 'Finds all methods that reference a given global entity.'
]

{ #category : 'Not categorized' }
AIFunctionFindReferences >> name [

	^ 'find_references'
]

{ #category : 'Not categorized' }
AIFunctionFindReferences >> parameters [

	^{
		AIFunctionParameterRequired
			name: 'variable_name'
			type: AIFunctionParameterTypeString new
			description: 'The name of the global variable, class, or pool dictionary to find references to'.
		AIFunctionParameterRequired name: 'with_source'
			type: AIFunctionParameterTypeBoolean new
			description: 'Include full source of implementors. Prefer false unless relevant' .
		AIFunctionParameterOptional
			name: 'classes'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Scope search to provided classes. Use if possible'.
		AIFunctionParameterOptional
			name: 'applications'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Scope search to provided applications. Use if possible' }
]
