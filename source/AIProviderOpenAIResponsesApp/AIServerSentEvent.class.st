Class {
	#name : 'AIServerSentEvent',
	#superclass : 'Object',
	#instVars : [
		'type',
		'data',
		'lastEventID'
	],
	#category : 'AIProviderOpenAIResponsesApp'
}

{ #category : 'Not categorized' }
AIServerSentEvent class >> type: type data: data lastEventID: lastEventID [

	^ self basicNew initializeWithType: type data: data lastEventID: lastEventID; yourself
]

{ #category : 'Not categorized' }
AIServerSentEvent >> = object [

	^ self class = object class and: [
		self type = object type and: [
			self data = object data and: [
				self lastEventID = object lastEventID ] ] ]
]

{ #category : 'Not categorized' }
AIServerSentEvent >> data [

	^ data
]

{ #category : 'Not categorized' }
AIServerSentEvent >> initializeWithType: initialType data: initialData lastEventID: initialLastEventID [

	self initialize.
	type := initialType.
	data := initialData.
	lastEventID := initialLastEventID.
]

{ #category : 'Not categorized' }
AIServerSentEvent >> lastEventID [

	^ lastEventID
]

{ #category : 'Not categorized' }
AIServerSentEvent >> type [

	^ type
]
