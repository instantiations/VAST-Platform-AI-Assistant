Class {
	#name : 'AIFunctionLibraryGetMethodSourceInEdition',
	#superclass : 'AIAbstractLibraryFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionLibraryGetMethodSourceInEdition >> applyFunctionTo: arguments in: context [
	| appName id className selector isClassSide appClass edition targetClassEdition methodSource findClassBlock |
	
	appName := arguments at: 'application'.
	id := arguments at: 'edition_identifier' ifAbsent: [ nil ].
	className := arguments at: 'class'.
	selector := arguments at: 'selector'.
	isClassSide := arguments at: 'is_class_side' ifAbsent: [ false ].
	
	appClass := self applicationNamed: appName.
	appClass ifNil: [ 
		^ EsOrderedDictionary with: 'error' -> ('Application not found: ', appName) ].
	
	id ifNil: [
		edition := appClass.
	] ifNotNil: [
		edition := appClass shadows detect: [:each | each versionName = id or: [each timeStamp printString = id] ] ifNone: [
			^ EsOrderedDictionary with: 'error' -> ('Edition not found: ', id) ].
	].
	
	"Recursive block to navigate subapplications looking for the class"
	findClassBlock := nil.
	findClassBlock := [:appEdition |
		| found |
		found := appEdition classes detect: [:each | each name = className asSymbol] ifNone: [ nil ].
		found ifNil: [
			(appEdition respondsTo: #subApplications) ifTrue: [
				appEdition subApplications do: [:sub |
					| subFound |
					subFound := findClassBlock value: sub.
					subFound ifNotNil: [ found := subFound ]
				].
			] ifFalse: [
				(appEdition respondsTo: #subApplicationsWithShadows) ifTrue: [
					appEdition subApplicationsWithShadows do: [:sub |
						| subFound |
						subFound := findClassBlock value: sub.
						subFound ifNotNil: [ found := subFound ]
					].
				].
			].
		].
		found
	].

	targetClassEdition := findClassBlock value: edition.
	targetClassEdition ifNil: [
		^ EsOrderedDictionary with: 'error' -> ('Class edition not found: ', className) ].
		
	isClassSide ifTrue: [ targetClassEdition := targetClassEdition class ].
	
	(targetClassEdition includesSelector: selector asSymbol) ifFalse: [
		^ EsOrderedDictionary with: 'error' -> ('Method not found: ', selector) ].
		
	"Use #sourceString instead of #source"
	methodSource := (targetClassEdition compiledMethodAt: selector asSymbol) sourceString.
	
	^ EsOrderedDictionary with: 'source' -> methodSource
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetMethodSourceInEdition >> description [
	^ 'Gets the source code of a specific method in a given application edition.'
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetMethodSourceInEdition >> name [
	^ 'get_method_source_in_edition'
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetMethodSourceInEdition >> parameters [
	^ {
		AIFunctionParameterRequired name: 'application'
			type: AIFunctionParameterTypeString new
			description: 'The name of the application'.
		AIFunctionParameterOptional name: 'edition_identifier'
			type: AIFunctionParameterTypeString new
			description: 'The version name or timestamp of the edition. If omitted, uses the loaded edition'.
		AIFunctionParameterRequired name: 'class'
			type: AIFunctionParameterTypeString new
			description: 'The name of the class'.
		AIFunctionParameterRequired name: 'selector'
			type: AIFunctionParameterTypeString new
			description: 'The selector of the method'.
		AIFunctionParameterOptional name: 'is_class_side'
			type: AIFunctionParameterTypeBoolean new
			description: 'True if it is a class method, false for instance method. Default false.'
	}
]
