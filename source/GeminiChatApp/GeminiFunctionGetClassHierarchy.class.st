Class {
	#name : 'GeminiFunctionGetClassHierarchy',
	#superclass : 'GeminiAbstractFunction',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiFunctionGetClassHierarchy >> applyFunctionTo: arguments in: context [

	| className hierarchy class |
	className := arguments at: 'class_name'.
	hierarchy := OrderedCollection new.
	
	class := self classNamed: className.
	class ifNil: [ 
		^ EsOrderedDictionary with: 'error' -> ('Class %1 not found' bindWith: className) ].

	[ class notNil ] whileTrue: [
		hierarchy add: class name.
		class := class superclass ].

	^ EsOrderedDictionary with: 'hierarchy' -> hierarchy
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassHierarchy >> description [

	^ 'Gets the superclass hierarchy of a class, starting from the class itself up to Object.'


]

{ #category : 'Not categorized' }
GeminiFunctionGetClassHierarchy >> name [

	^ 'get_class_hierarchy'
]

{ #category : 'Not categorized' }
GeminiFunctionGetClassHierarchy >> parameters [

	^ {
		GeminiFunctionParameterRequired name: 'class_name'
			type: GeminiFunctionParameterTypeString new
			description: 'The name of the class to get the hierarchy for' }

]
