Class {
	#name : 'AIJSONReaderTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Asserting' }
AIJSONReaderTest >> assertJSON: json isReadAsString: expectedString [

	| jsonValue |

	jsonValue := (AIJSONReader on: (AIPeekableStream on: (AICharacterGraphemeStream on: (AIUTF8DecodingStream on: json utf8)))) next.
	self assert: jsonValue equals: expectedString.
	self assert: jsonValue isUnicodeString equals: expectedString isUnicodeString.
]

{ #category : 'Tests' }
AIJSONReaderTest >> test [

	self assertJSON: '"x"' isReadAsString: 'x'.
	self assertJSON: (UnicodeString escaped: '"\u{7F}"') isReadAsString: (String with: (Character value: 16r7F)).
	self assertJSON: (UnicodeString escaped: '"\u{80}"') isReadAsString: (UnicodeString escaped: '\u{80}').
	self assertJSON: (UnicodeString escaped: '"\u{100}"') isReadAsString: (UnicodeString escaped: '\u{100}').
	self assertJSON: (UnicodeString escaped: '"\u{20DD}"') isReadAsString: (UnicodeString escaped: '\u{20DD}').
	self assertJSON: (UnicodeString escaped: '"\u{10000}"') isReadAsString: (UnicodeString escaped: '\u{10000}').

	self assertJSON: '"\\"' isReadAsString: '\'.
	self assertJSON: '"\n"' isReadAsString: String lf.
	self assertJSON: '"\u0022"' isReadAsString: '"'.
	self assertJSON: '"\u007F"' isReadAsString: (String with: (Character value: 16r7F)).
	self assertJSON: '"\u0080"' isReadAsString: (UnicodeString escaped: '\u{80}').
	self assertJSON: '"\u0100"' isReadAsString: (UnicodeString escaped: '\u{100}').
	self assertJSON: '"\u20DD"' isReadAsString: (UnicodeString escaped: '\u{20DD}').
	self assertJSON: '"\uD800\uDC00"' isReadAsString: (UnicodeString escaped: '\u{10000}').
]
