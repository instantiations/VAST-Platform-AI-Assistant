Extension {
	#name : 'EmShadowSubApplication'
}

{ #category : 'Not categorized' }
EmShadowSubApplication class >> aiJSON [
	^ EsOrderedDictionary 
		with: 'version_name' -> (self versionName ifNil: [''])
		with: 'timestamp' -> self timeStamp printString
		with: 'is_version' -> self isVersion
]
