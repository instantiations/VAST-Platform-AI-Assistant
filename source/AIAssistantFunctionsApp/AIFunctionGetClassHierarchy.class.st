Class {
	#name : 'AIFunctionGetClassHierarchy',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionGetClassHierarchy >> applyFunctionTo: arguments in: context [

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
AIFunctionGetClassHierarchy >> description [

	^ 'Gets the superclass hierarchy of a class, starting from the class itself up to Object.'


]

{ #category : 'Not categorized' }
AIFunctionGetClassHierarchy >> name [

	^ 'get_class_hierarchy'
]

{ #category : 'Not categorized' }
AIFunctionGetClassHierarchy >> parameters [

	^ {
		AIFunctionParameterRequired name: 'class_name'
			type: AIFunctionParameterTypeString new
			description: 'The name of the class to get the hierarchy for' }

]
