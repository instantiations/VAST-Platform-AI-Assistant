Extension {
	#name : 'CgFontStruct'
}

{ #category : 'CG-API' }
CgFontStruct >> textWidth: string drawable: drawable [

	^(fid notNil and: [fid isValidFont])
		ifTrue: [fid textWidth: string drawable: drawable]
		ifFalse: [self textWidth: string]
]
