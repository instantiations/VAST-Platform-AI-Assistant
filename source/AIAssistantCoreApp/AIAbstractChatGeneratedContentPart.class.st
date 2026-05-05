Class {
	#name : 'AIAbstractChatGeneratedContentPart',
	#superclass : 'Object',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIAbstractChatGeneratedContentPart >> isFunctionCall [

	^ false
]

{ #category : 'Not categorized' }
AIAbstractChatGeneratedContentPart >> isText [

	^ false
]

{ #category : 'Not categorized' }
AIAbstractChatGeneratedContentPart >> json [

	self subclassResponsibility
]
