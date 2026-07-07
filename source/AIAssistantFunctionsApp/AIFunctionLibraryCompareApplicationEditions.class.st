Class {
	#name : 'AIFunctionLibraryCompareApplicationEditions',
	#superclass : 'AIFunctionLibraryCompareEditions',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionLibraryCompareApplicationEditions >> applyFunctionTo: arguments in: context [
	| appName id1 id2 includeSubapps appClass edition1 edition2 diffs |
	
	appName := arguments at: 'application'.
	id1 := arguments at: 'edition_1_identifier'.
	id2 := arguments at: 'edition_2_identifier' ifAbsent: [ nil ].
	includeSubapps := arguments at: 'include_subapplications' ifAbsent: [ true ].
	
	appClass := self applicationNamed: appName.
	appClass ifNil: [ 
		^ EsOrderedDictionary with: 'error' -> ('Application not found: ', appName) ].
	
	edition1 := appClass shadows detect: [:each | each versionName = id1 or: [each timeStamp printString = id1] ] ifNone: [
		^ EsOrderedDictionary with: 'error' -> ('Edition 1 not found: ', id1) ].
	
	id2 ifNil: [
		edition2 := appClass.
	] ifNotNil: [
		edition2 := appClass shadows detect: [:each | each versionName = id2 or: [each timeStamp printString = id2] ] ifNone: [
			^ EsOrderedDictionary with: 'error' -> ('Edition 2 not found: ', id2) ].
	].
		
	diffs := edition2 differencesWith: edition1 includeSubApplications: includeSubapps.
	
	^ EsOrderedDictionary with: 'differences' -> (self formatDifferences: diffs)
]

{ #category : 'Not categorized' }
AIFunctionLibraryCompareApplicationEditions >> description [
	^ 'Compares two application editions, returning a summary of the differences.'
]

{ #category : 'Not categorized' }
AIFunctionLibraryCompareApplicationEditions >> name [
	^ 'compare_application_editions'
]

{ #category : 'Not categorized' }
AIFunctionLibraryCompareApplicationEditions >> parameters [
	^ {
		AIFunctionParameterRequired name: 'application'
			type: AIFunctionParameterTypeString new
			description: 'The name of the application to check for changes'.
		AIFunctionParameterRequired name: 'edition_1_identifier'
			type: AIFunctionParameterTypeString new
			description: 'The version name or timestamp of the first edition to compare'.
		AIFunctionParameterOptional name: 'edition_2_identifier'
			type: AIFunctionParameterTypeString new
			description: 'The version name or timestamp of the second edition. If omitted, the loaded edition is used'.
		AIFunctionParameterOptional name: 'include_subapplications'
			type: AIFunctionParameterTypeBoolean new
			description: 'Whether to recursively compare subapplications. Default is true'.
	}
]
