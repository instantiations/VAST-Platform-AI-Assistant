Extension {
	#name : 'Collection'
}

{ #category : 'AIAssistant' }
Collection >> aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit [
	"Answer a JSON-serializable dictionary representing the receiver collection,
	 including its size, instance variables, and up to indexedLimit element references."

	| size limit dict elements count |

	"Guard size retrieval in case the collection is uninitialized or in an inconsistent state."
	size := [ self size ] on: Error do: [ :ex | ex return: nil ].

	"Clamp indexedLimit to be non-negative and avoid over-allocating when size is smaller."
	limit := indexedLimit max: 0.
	elements := OrderedCollection new: (size ifNil: [ limit ] ifNotNil: [ (size min: limit) max: 0 ]).
	dict := EsOrderedDictionary new.
	dict
		at: 'class' put: self class name asString;
		at: 'object_handle' put: (context objectRegistry register: self);
		at: 'size' put: size;
		at: 'instance_variables' put: (self aiInstanceVariablesJSONInContext: context stringsLimitedTo: stringLimit);
		at: 'elements' put: elements.

	limit = 0 ifTrue: [ ^ dict ].

	"Protect iteration so a partially initialized or mid-mutation collection still returns
	 its metadata, instance variables, and any elements collected before the failure."
	count := 0.
	[
		self do: [ :each |
			count >= limit ifTrue: [ ^ dict ].
			elements add: (each aiJSONReferenceInContext: context printStringLimitedTo: stringLimit).
			count := count + 1 ]
	] on: Error do: [ :ex | ex return: nil ].

	^ dict
]
