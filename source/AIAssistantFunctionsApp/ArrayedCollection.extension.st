Extension {
	#name : 'ArrayedCollection'
}

{ #category : 'AIAssistant' }
ArrayedCollection >> aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit [
	"Answer a JSON-serializable dictionary representing the receiver.
	 For non-pointer arrayed collections (such as String, Symbol, ByteArray, Utf8),
	 omit individual indexed elements and serialize as a reference with a protected print_string."

	self class isPointers ifFalse: [
		^ self aiJSONReferenceInContext: context printStringLimitedTo: stringLimit ].

	^ super
		aiJSONInContext: context
		stringsLimitedTo: stringLimit
		indexedLimitedTo: indexedLimit
]
