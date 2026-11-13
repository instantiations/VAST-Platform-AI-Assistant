Class {
	#name : 'AIFunctionTestCase',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Helpers' }
AIFunctionTestCase >> applyFunction: functionClass withArguments: args [

	^ self applyFunction: functionClass withArguments: args inContext: self emptyContext
]

{ #category : 'Helpers' }
AIFunctionTestCase >> applyFunction: functionClass withArguments: args inContext: context [

	^ functionClass new applyFunctionTo: args in: context
]

{ #category : 'Helpers' }
AIFunctionTestCase >> assertSubApplicationScopedForFunction: functionClass withArguments: args matchingClassBlock: classBlock [

	| subApp siblingSubApp result foundClasses siblingDefinedClasses |
	subApp := System loadedSubApplications
		detect: [:app |
			app isSubApplication and: [
				app parent notNil and: [
					app parent subApplications size >= 2 and: [
						app defined anySatisfy: classBlock]]]]
		ifNone: [^self].
	siblingSubApp := (subApp parent subApplications copyWithout: subApp) first.

	args
		at: 'with_source' put: false;
		at: 'applications' put: (Array with: subApp name asString).
	result := self applyFunction: functionClass withArguments: args inContext: nil.

	foundClasses := ((result at: 'methods') collect: [:m | (m at: 'class') asString]) asSet.
	siblingDefinedClasses := Set new.
	siblingSubApp withAllSubApplications do: [:s |
		siblingDefinedClasses addAll: (s defined collect: [:c | c name asString])].

	self deny: foundClasses isEmpty.
	foundClasses do: [:cls | self deny: (siblingDefinedClasses includes: cls)]
]

{ #category : 'Helpers' }
AIFunctionTestCase >> contextForChat: aChat [

	^ AIFunctionCallContext
		model: aChat model
		filePaths: aChat filePaths
		codeChanges: OrderedCollection new
		objectRegistry: aChat objectRegistry
		workspaceRegistry: aChat workspaceRegistry
]

{ #category : 'Helpers' }
AIFunctionTestCase >> contextWithChange: aChange [

	| chat |
	chat := AITestChat new.
	^ AIFunctionCallContext
		model: nil
		filePaths: #()
		codeChanges: (OrderedCollection with: aChange)
		objectRegistry: chat objectRegistry
		workspaceRegistry: chat workspaceRegistry
]

{ #category : 'Helpers' }
AIFunctionTestCase >> contextWithModel: aModel [

	| chat |
	chat := AITestChat new.
	chat model: aModel.
	^ self contextForChat: chat
]

{ #category : 'Helpers' }
AIFunctionTestCase >> emptyContext [

	^ self contextForChat: AITestChat new
]
