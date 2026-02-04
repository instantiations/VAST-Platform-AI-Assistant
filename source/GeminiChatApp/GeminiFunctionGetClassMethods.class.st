Class {
	#name : 'GeminiFunctionGetClassMethods',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetClassMethods >> applyFunctionTo: arguments in: context [

	| withSource |

	withSource := arguments at: 'with_source'.
	^ self response: 'methods_per_side_per_class'
		collect: [ :class |
			(EsOrderedDictionary with: 'instance' -> class with: 'class' -> class class) collect: [ :methodClass |
				methodClass selectors collect: [ :selector |
					| methodInfo |
					methodInfo := EsOrderedDictionary
						with: 'categories' -> (methodClass categoriesFor: selector)
						with: 'selector' -> selector.
					withSource ifTrue: [
						methodInfo at: 'source' put: (methodClass sourceCodeAt: selector) ].
					methodInfo ] ] ]
		forClassesNamed: (arguments at: 'classes')
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
			description: 'Whether to include the full source of each method, prefer excluding the source to get an overview of a class' }
]
