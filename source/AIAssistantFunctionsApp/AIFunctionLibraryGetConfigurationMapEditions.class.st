Class {
	#name : 'AIFunctionLibraryGetConfigurationMapEditions',
	#superclass : 'AIAbstractLibraryFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionLibraryGetConfigurationMapEditions >> applyFunctionTo: arguments in: context [
	| mapName editions mappedEditions |
	
	mapName := arguments at: 'configuration_map'.
	
	(self configurationMapClass configurationMapNames includes: mapName) ifFalse: [
		^ EsOrderedDictionary with: 'error' -> ('Configuration map not found: ', mapName) ].
	
	editions := self configurationMapClass editionsFor: mapName.
	
	mappedEditions := editions collect: [:each | each aiJSON ].
	
	^ EsOrderedDictionary with: 'editions' -> mappedEditions
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetConfigurationMapEditions >> description [
	^ 'Lists the editions/versions of a configuration map, providing their version names and timestamps.'
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetConfigurationMapEditions >> name [
	^ 'get_configuration_map_editions'
]

{ #category : 'Not categorized' }
AIFunctionLibraryGetConfigurationMapEditions >> parameters [
	^ {
		AIFunctionParameterRequired name: 'configuration_map'
			type: AIFunctionParameterTypeString new
			description: 'The name of the configuration map'.
	}
]
