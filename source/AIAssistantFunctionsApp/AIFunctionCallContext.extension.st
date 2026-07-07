Extension {
	#name : 'AIFunctionCallContext'
}

{ #category : 'Accessing' }
AIFunctionCallContext >> proposedSelectors [

	| selectors |

	selectors := Set new.
	codeChanges do: [ :change |
		change isMethodChange ifTrue: [
			selectors add: change selector ] ].
	^ selectors
]
