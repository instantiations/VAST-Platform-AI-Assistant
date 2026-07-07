Class {
	#name : 'AIFunctionLibraryCompareEditions',
	#superclass : 'AIAbstractLibraryFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AIFunctionLibraryCompareEditions class >> isAbstract [

	^self == AIFunctionLibraryCompareEditions or: [super isAbstract]
]

{ #category : 'Not categorized' }
AIFunctionLibraryCompareEditions >> formatDifferences: diffs [
	| stream foundAnyDifferences |
	stream := WriteStream on: String new.
	foundAnyDifferences := false.
	
	diffs keysAndValuesDo: [:subApp1 :assoc |
		| subApp2 classDiffs |
		subApp2 := assoc key.
		classDiffs := assoc value.
		
		classDiffs isEmpty ifFalse: [
			foundAnyDifferences := true.
			stream nextPutAll: 'Application: ', subApp2 name; cr.
			
			classDiffs keysAndValuesDo: [:classShadow1 :classEditionDiff |
				| classShadow2 def1 def2 newLineSpaces |
				stream nextPutAll: '  Class: ', classShadow1 name; cr.
				
				classShadow2 := subApp2 classes detect: [:each | each name = classShadow1 name] ifNone: [ nil ].
				def1 := classShadow1 definitionString ifNil: [''].
				def2 := classShadow2 ifNotNil: [ classShadow2 definitionString ] ifNil: [''].
				
				def1 trimBlanks ~= def2 trimBlanks ifTrue: [
					newLineSpaces := String cr, '      '.
					stream nextPutAll: '    [Class Definition Changed]'; cr.
					stream nextPutAll: '      From: ', (def1 copyReplaceAll: String cr with: newLineSpaces); cr.
					stream nextPutAll: '      To:   ', (def2 copyReplaceAll: String cr with: newLineSpaces); cr.
				].
				
				classEditionDiff selectors isEmpty ifFalse: [
					stream nextPutAll: '    Instance Methods:'; cr.
					classEditionDiff selectors asSortedCollection do: [:sel |
						stream nextPutAll: '      ', sel; cr.
					].
				].
			
				classEditionDiff class selectors isEmpty ifFalse: [
					stream nextPutAll: '    Class Methods:'; cr.
					classEditionDiff class selectors asSortedCollection do: [:sel |
						stream nextPutAll: '      ', sel; cr.
					].
				].
			].
		].
	].
	
	foundAnyDifferences ifFalse: [ ^ 'No differences found.' ].
	^ stream contents
]
