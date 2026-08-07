Class {
	#name : 'AIAddClassChange',
	#superclass : 'AddClassChange',
	#instVars : [
		'patchedClassInstanceVariableNames',
		'controller'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'AI Extensions' }
AIAddClassChange >> aiIsClassChangeForClassNamed: targetClassName [
	
	^ self changeClassName asString = targetClassName
]

{ #category : 'accessing' }
AIAddClassChange >> classInstanceVariableNames [
	"Note: the instance variable name is chosen to not interfere with a correction made to the superclass 
	 in later versions of VAST than where the absence of support class instance variables was introduced."

	patchedClassInstanceVariableNames isNil ifTrue: [self fillOutDefinition].
	^patchedClassInstanceVariableNames
]

{ #category : 'AI Extensions' }
AIAddClassChange >> controller [
	^controller
]

{ #category : 'accessing' }
AIAddClassChange >> fillOutDefinition [

	| parseTree parts |

	parseTree := RBParser parseExpression: definition onError: [:str :pos | ^self parseDefinitionError].
	parseTree isMessage ifFalse: [^self parseDefinitionError].
	(self isValidSubclassCreationMessage: parseTree) ifFalse: [^self parseDefinitionError].
	
	superclassName :=
		parseTree receiver isVariable
			ifTrue: [parseTree receiver name asSymbol]
			ifFalse: [parseTree receiver value].
	className := parseTree arguments first value.
	patchedClassInstanceVariableNames := #().
	instanceVariableNames := #().
	classVariableNames := #().
	poolDictionaryNames := #().

	parts := parseTree selectorParts collect:[:part | part value asString].
	parts doWithIndex: [:part :index | | argValue |
		argValue := self namesIn: (parseTree arguments at: index) value.
		part = 'classInstanceVariableNames:' ifTrue: [patchedClassInstanceVariableNames := argValue].
		part = 'instanceVariableNames:' ifTrue: [instanceVariableNames := argValue].
		part = 'classVariableNames:' ifTrue: [classVariableNames := argValue].
		part = 'poolDictionaries:' ifTrue: [poolDictionaryNames := argValue]]
]

{ #category : 'accessing' }
AIAddClassChange >> isClassChange [
	^true
]

{ #category : 'accessing' }
AIAddClassChange >> parseDefinitionError [
	super parseDefinitionError.
	patchedClassInstanceVariableNames := #()
]

{ #category : 'private' }
AIAddClassChange >> primitiveExecute [

	| class oldApp possibleTargetApps compileResult |

	compileResult := super primitiveExecute.
	compileResult isNil ifTrue: [^self].

	class := Smalltalk classAt: self changeClassName asSymbol.

	oldApp := class controller.
	oldApp ~= self application 
		ifTrue: [
			"For now, if the class cannot be moved to the other application, the user is notified. 
			To be improved in the future by preventing the change (and possibly notifying the llm about it in the function call)."
			possibleTargetApps := EtTools managerInterface applicationsToMove: { class } from: oldApp verifyGroupMember: StsPowerToolsKernel superUser not.
			(possibleTargetApps includes: self application)
				ifFalse: [^System message: ('The selected class could not be moved to %1. Verify and perform this change using other tools.' bindWith: self application name)].
			self
				do: [class moveEditionFrom: oldApp to: self application]
				forApp: oldApp
				withSuperUser: (class ownerIn: oldApp)]
]

{ #category : 'accessing' }
AIAddClassChange >> validateDefinition [

	| parseTree |

	parseTree :=
		RBParser
			parseExpression: definition
			onError: [:str :pos | ^'Parse error in definition: %1.' bindWith: str].
	parseTree isMessage ifFalse: [^'Definition expression should be a message.'].
	(self isValidSubclassCreationMessage: parseTree) ifFalse: [ ^'Definition expression is not a known class creation message.'].
	^ nil
]
