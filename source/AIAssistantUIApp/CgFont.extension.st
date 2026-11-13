Extension {
	#name : 'CgFont'
}

{ #category : 'CG-Internal',
  #vaVisibility : 'private' }
CgFont >> textWidth: string drawable: drawable [

	| hdc oldHfont size |

	string size == 0 ifTrue: [^0].
	server beginRequest.
	hdc := server deviceContext.
	oldHfont :=
		hdc selectObject:
			(DPIScaler autoScaleObject: (serverResource handle) for: (drawable autoScaleContext)).
	size := string cgTextExtent: hdc validator: serverResource.
	hdc selectObject: oldHfont.
	server endRequest.
	^DPIScaler autoScaleDown: (size cx) for: (drawable autoScaleContext)
]
