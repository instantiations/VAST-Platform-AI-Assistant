Extension {
	#name : 'UnicodeString'
}

{ #category : 'AIAssistant' }
UnicodeString >> aiJSONInContext: context stringsLimitedTo: stringLimit indexedLimitedTo: indexedLimit [

	| dict |

	dict := EsOrderedDictionary new.
	dict
		at: 'class' put: self class name asString;
		at: 'print_string' put: (self printStringLimitedTo: stringLimit);
		at: 'object_handle' put: (context objectRegistry register: self).

	^ dict
]
