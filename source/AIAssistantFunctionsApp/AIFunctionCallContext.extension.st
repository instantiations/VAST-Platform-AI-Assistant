Extension {
	#name : 'AIFunctionCallContext'
}

{ #category : 'Accessing' }
AIFunctionCallContext >> proposedClasses [

	| classNames |

	classNames := Set new.
	codeChanges do: [ :change |
		change isClassChange ifTrue: [
			classNames add: change changeClassName asString ] ].
	^ classNames
]

{ #category : 'Accessing' }
AIFunctionCallContext >> proposedSelectors [

	| selectors |

	selectors := Set new.
	codeChanges do: [ :change |
		change isMethodChange ifTrue: [
			selectors add: change selector ] ].
	^ selectors
]
