Class {
	#name : 'AIAbstractChatGenerationLogEntry',
	#superclass : 'Object',
	#instVars : [
		'timestamp',
		'model',
		'requestObject',
		'retainedObjects'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized',
  #vaVisibility : 'private' }
AIAbstractChatGenerationLogEntry >> initializeRetainedObjects [

	| buckets pendingObjects objectIndex |

	buckets := Array new: 10.
	1 to: buckets size do: [ :bucketIndex |
		buckets at: bucketIndex put: IdentitySet new ].
	pendingObjects := OrderedCollection withAll: self retainedObjectsRoots.
	[ pendingObjects notEmpty ] whileTrue: [
		| object bucket |
		object := pendingObjects removeLast.
		bucket := buckets at: object basicHash \\ buckets size + 1.
		(bucket includes: object) ifFalse: [
			bucket add: object.
			1 to: object numberOfPointerFields do: [ :fieldIndex |
				| referencedObject |
				(referencedObject := object instVarAt: fieldIndex) isImmediateForDumping ifFalse: [
					pendingObjects add: referencedObject ] ] ] ].
	retainedObjects := Array new: (buckets inject: 0 into: [ :totalSize :bucket | totalSize + bucket size ]).
	objectIndex := 0.
	buckets do: [ :bucket |
		bucket do: [ :retainedObject |
			retainedObjects at: (objectIndex := objectIndex + 1) put: retainedObject ] ]
]

{ #category : 'Not categorized' }
AIAbstractChatGenerationLogEntry >> initializeWithTimestamp: initialTimestamp model: initialModel requestObject: initialRequestObject [

	self initialize.
	timestamp := initialTimestamp.
	model := initialModel.
	requestObject := initialRequestObject.
]

{ #category : 'Not categorized' }
AIAbstractChatGenerationLogEntry >> retainedObjects [

	^ retainedObjects
]

{ #category : 'Not categorized' }
AIAbstractChatGenerationLogEntry >> retainedObjectsRoots [

	^ { requestObject }
]
