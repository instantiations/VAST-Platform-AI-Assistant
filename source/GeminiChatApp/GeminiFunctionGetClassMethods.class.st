Class {
	#name : 'GeminiFunctionGetClassMethods',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetClassMethods >> applyFunctionTo: arguments in: context [

	| includeSource filters maxResults methodsCount resultPerClass classesNotFound classNames |

	includeSource := (arguments at: 'with_source').
	filters := arguments at: 'filters' ifAbsent: [#()].
	maxResults := self resultLimitFor: context withSource: includeSource.
	methodsCount := 0.
	classNames := arguments at: 'classes'.
	resultPerClass := EsOrderedDictionary new.
	classesNotFound := OrderedCollection new.

	classNames do: [:className |
		(self classNamed: className)
			ifNotNil: [:class | | classMethods |
				classMethods := EsOrderedDictionary new.
				(EsOrderedDictionary with: 'instance' -> class with: 'class' -> class class)
					keysAndValuesDo: [:side :methodClass | | sideMethods matchingSelectors |
						sideMethods := OrderedCollection new.
						matchingSelectors := methodClass selectors.
						filters isEmpty ifFalse: [
							matchingSelectors :=
								matchingSelectors select: [:selector |
									filters anySatisfy: [:filter | filter match: selector asString]]].

						matchingSelectors do: [:selector |
							methodsCount := methodsCount + 1.
							sideMethods add: (
								includeSource
									ifTrue: [ (methodClass compiledMethodAt: selector) geminiJSON ]
									ifFalse: [(methodClass compiledMethodAt: selector) geminiJSONWithoutSource]).
							methodsCount >= maxResults
								ifTrue: [
									classMethods at: side put: sideMethods.
									resultPerClass at: className put: classMethods.
									^EsOrderedDictionary
										with: 'methods_per_side_per_class' -> resultPerClass
										with:
											'nonexistent_or_outside_scope_classes' -> classesNotFound
										with:
											'warning' -> (
												'Results exceeded maximum limit of %1. Please retry with a more restricted scope or use another function.'
													bindWith: maxResults)]].
						classMethods at: side put: sideMethods].
				resultPerClass at: className put: classMethods]
			ifNil: [classesNotFound add: className]].

	^EsOrderedDictionary
		with: 'methods_per_side_per_class' -> resultPerClass
		with: 'nonexistent_or_outside_scope_classes' -> classesNotFound
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassMethods >> description [

	^ 'Gets the source code, or just the selector, and the categories of each method for the given classes, grouped by instance side and class side.'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassMethods >> name [

	^ 'get_class_methods'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassMethods >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'classes'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Names of the classes'.
		GeminiFunctionParameterRequired name: 'with_source'
			type: GeminiFunctionParameterTypeBoolean new
			description: 'Include full source of methods. Prefer false unless relevant. 
			Use find_implementors scoped to class instead, if interested in source of a single method'.
		GeminiFunctionParameterOptional name: 'filters'
			type: (GeminiFunctionParameterTypeArray itemsType: GeminiFunctionParameterTypeString new)
			description: 'Selectors to filter methods by. Can contain wildcards like * (e.g., backgroundCol*, *background). If not set, all methods are returned.'
	}
]
