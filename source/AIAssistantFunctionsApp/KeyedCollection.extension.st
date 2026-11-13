Extension {
	#name : 'KeyedCollection'
}

{ #category : 'AIAssistant' }
KeyedCollection >> aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit [
	"Answer a JSON-serializable dictionary representing the receiver keyed collection,
	 mapping printed keys (with collision suffixes if needed) to value references up to indexedLimit."

	| size limit dict count elements |

	"Guard size retrieval in case the dictionary is uninitialized or being rehashed."
	size := [ self size ] on: Error do: [ :ex | ex return: nil ].

	"Clamp indexedLimit to be non-negative and avoid over-allocating when size is smaller."
	limit := indexedLimit max: 0.
	dict := EsOrderedDictionary new.
	elements := EsOrderedDictionary new: (size ifNil: [ limit ] ifNotNil: [ (size min: limit) max: 0 ]).
	dict
		at: 'class' put: self class name asString;
		at: 'object_handle' put: (context objectRegistry register: self);
		at: 'size' put: size;
		at: 'instance_variables' put: (self aiInstanceVariablesJSONInContext: context stringsLimitedTo: stringLimit);
		at: 'elements' put: elements.

	limit = 0 ifTrue: [ ^ dict ].

	"Protect iteration so a partially initialized or mid-mutation keyed collection still returns
	 its metadata, instance variables, and any entries collected before the failure."
	count := 0.
	[
		self keysAndValuesDo: [ :key :value |
			| baseKeyString keyString collisionIndex valueJSON |
			count >= limit ifTrue: [ ^ dict ].
			baseKeyString := [ key printStringLimitedTo: stringLimit ]
				on: Error
				do: [ :sig | sig return: 'Could not print object' ].
			"Disambiguate keys that produce identical print strings."
			keyString := baseKeyString.
			collisionIndex := 2.
			[ elements includesKey: keyString ] whileTrue: [
				keyString := baseKeyString , ' (' , collisionIndex printString , ')'.
				collisionIndex := collisionIndex + 1 ].
			valueJSON := value aiJSONReferenceInContext: context printStringLimitedTo: stringLimit.
			elements at: keyString put: valueJSON.
			count := count + 1 ]
	] on: Error do: [ :ex | ex return: nil ].

	^ dict
]
