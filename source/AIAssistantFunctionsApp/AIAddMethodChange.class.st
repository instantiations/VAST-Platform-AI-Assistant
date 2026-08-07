Class {
	#name : 'AIAddMethodChange',
	#superclass : 'AddMethodChange',
	#instVars : [
		'controller'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Initialization' }
AIAddMethodChange class >> compile: source inClassNamed: classNameSymbol protocols: categories application: app isPrivate: isPrivate isClassSide: isClassSide [

	^self new
		application: app
		className: classNameSymbol
		protocols: categories
		source: source
		isPrivate: isPrivate
		isClassSide: isClassSide
]

{ #category : 'accessing' }
AIAddMethodChange >> application: anApplication [

	application := anApplication
]

{ #category : 'initialize-release' }
AIAddMethodChange >> application: anApplication className: aClassName protocols: aProtocolCollection source: aString isPrivate: aBoolean isClassSide: isClassSide [

	self changeClassName: aClassName.
	source := aString.
	application := anApplication.
	self protocols: aProtocolCollection.
	isPrivate := aBoolean.
	isMeta :=  isClassSide
]

{ #category : 'accessing' }
AIAddMethodChange >> controller [
	^controller
]

{ #category : 'accessing' }
AIAddMethodChange >> isMethodChange [
	^true
]

{ #category : 'accessing' }
AIAddMethodChange >> isPrivate [
	^ isPrivate
]

{ #category : 'accessing' }
AIAddMethodChange >> isPrivate: aBoolean [

	isPrivate := aBoolean
]

{ #category : 'private',
  #vaVisibility : 'private' }
AIAddMethodChange >> primitiveExecute [

	| method possibleTargetApps compileResult |

	compileResult := super primitiveExecute.
	compileResult isNil ifTrue: [^self].

	self changeClass categoriesFor: self selector are: self protocols.
	
	method := self changeClass compiledMethodAt: self selector.
	method application ~= self application
		ifTrue:[
			"For now, if the method cannot be moved to the other application, the user is notified. 
			To be improved in the future by preventing the change (and possibly notifying the llm about it in the function call)."
			possibleTargetApps := Set withAll: method methodClass applications.
			possibleTargetApps addAll: (EtTools managerInterface applicationsThatCanExtendAll: { self changeClass }).
			(possibleTargetApps includes: self application)
				ifFalse: [ ^System message: ('The selected method cannot be moved to %1. Verify and perform this change using other tools.' bindWith: self application name)].

			(self stsSuperUser or: [self application stsIsSuperGroup])
				ifTrue: [
					self
						changeUserTo: (method methodClass developerIn: method application)
						for: [method methodClass moveSelector: method selector to: self application]]
				ifFalse: [method methodClass moveSelector: method selector to: self application]]
]
