Class {
	#name : 'AIAddClassChange',
	#superclass : 'AddClassChange',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'accessing' }
AIAddClassChange >> isClassChange [
	^true
]

{ #category : 'private',
  #vaVisibility : 'private' }
AIAddClassChange >> primitiveExecute [

	| class oldApp possibleTargetApps |

	super primitiveExecute.
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
