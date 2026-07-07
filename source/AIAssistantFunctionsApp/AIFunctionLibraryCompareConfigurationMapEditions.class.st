Class {
	#name : 'AIFunctionLibraryCompareConfigurationMapEditions',
	#superclass : 'AIFunctionLibraryCompareEditions',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionLibraryCompareConfigurationMapEditions >> applyFunctionTo: arguments in: context [
	| mapName id1 id2 editions edition1 edition2 diffs |
	
	mapName := arguments at: 'configuration_map'.
	id1 := arguments at: 'edition_1_identifier'.
	id2 := arguments at: 'edition_2_identifier' ifAbsent: [ nil ].
	
	(self configurationMapClass configurationMapNames includes: mapName) ifFalse: [
		^ EsOrderedDictionary with: 'error' -> ('Configuration map not found: ', mapName) ].
		
	editions := self configurationMapClass editionsFor: mapName asSymbol.
	
	edition1 := editions detect: [:each | each versionName = id1 or: [each timeStamp printString = id1] ] ifNone: [
		^ EsOrderedDictionary with: 'error' -> ('Edition 1 not found: ', id1) ].
	
	id2 ifNil: [
		edition2 := editions detect: [:each | true] ifNone: [ nil ].
		edition2 ifNil: [ ^ EsOrderedDictionary with: 'error' -> 'No edition found' ]
	] ifNotNil: [
		edition2 := editions detect: [:each | each versionName = id2 or: [each timeStamp printString = id2] ] ifNone: [
			^ EsOrderedDictionary with: 'error' -> ('Edition 2 not found: ', id2) ].
	].
	
	diffs := edition2 differencesWith: edition1.
	
	^ EsOrderedDictionary with: 'differences' -> (self formatDifferences: diffs)
]

{ #category : 'Not categorized' }
AIFunctionLibraryCompareConfigurationMapEditions >> description [
	^ 'Compares two configuration map editions, returning a summary of the differences.'
]

{ #category : 'Not categorized' }
AIFunctionLibraryCompareConfigurationMapEditions >> name [
	^ 'compare_configuration_map_editions'
]

{ #category : 'Not categorized' }
AIFunctionLibraryCompareConfigurationMapEditions >> parameters [
	^ {
		AIFunctionParameterRequired name: 'configuration_map'
			type: AIFunctionParameterTypeString new
			description: 'The name of the configuration map to check for changes'.
		AIFunctionParameterRequired name: 'edition_1_identifier'
			type: AIFunctionParameterTypeString new
			description: 'The version name or timestamp of the first edition to compare'.
		AIFunctionParameterOptional name: 'edition_2_identifier'
			type: AIFunctionParameterTypeString new
			description: 'The version name or timestamp of the second edition. If omitted, the most recent edition is used'.
	}
]
