Class {
	#name : 'AIRefactoryChangeTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIRefactoryChangeTest >> testChangeClassCompilerErrorNotifiesController [
	| controller change |

	controller := AIMockCompilerController new.
	"A trailing + creates a syntax error, which causes the Compiler to fail and notify the controller"
	change := AIAddClassChange 
		definition: 'Object subclass: #AIInvalidClass instanceVariableNames: ''-'' + '
		application: AIAssistantTestsApp.
	
	change executeWithController: controller.
	
	self assert: controller errorReported notNil.
	self assert: (controller errorReported isKindOf: CompilerError).
]

{ #category : 'Tests' }
AIRefactoryChangeTest >> testChangeMethodCompilerErrorNotifiesController [
	| controller change |

	controller := AIMockCompilerController new.
	change := AIAddMethodChange 
		compile: 'foo ^ 1 + '
		inClassNamed: #AIRefactoryChangeTest 
		protocols: #('accessing') 
		application: AIAssistantTestsApp 
		isPrivate: false 
		isClassSide: false.
	
	change executeWithController: controller.
	
	self assert: controller errorReported notNil.
	self assert: (controller errorReported isKindOf: CompilerError).
]
