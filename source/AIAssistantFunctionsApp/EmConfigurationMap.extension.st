Extension {
	#name : 'EmConfigurationMap'
}

{ #category : 'Not categorized' }
EmConfigurationMap >> aiJSON [
	^ EsOrderedDictionary 
		with: 'version_name' -> (self versionName ifNil: [''])
		with: 'timestamp' -> self timeStamp printString
		with: 'is_version' -> self isVersion
]
