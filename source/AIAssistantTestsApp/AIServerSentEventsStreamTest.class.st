Class {
	#name : 'AIServerSentEventsStreamTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIServerSentEventsStreamTest >> assertErrorWhenReadingStream: stream [

	self deny: stream atEnd.
	self should: [ stream next ] raise: Error.
]

{ #category : 'Not categorized' }
AIServerSentEventsStreamTest >> assertStream: stream readsEvents: expectedEvents [

	expectedEvents do: [ :expectedEvent |
		self deny: stream atEnd.
		self assert: stream next equals: expectedEvent ].
	self assert: stream atEnd.
	self assert: stream next isNil.
]

{ #category : 'Not categorized' }
AIServerSentEventsStreamTest >> streamOnByteArray: byteArray [

	^ AIServerSentEventsStream on: (AIPeekableStream on: (AICharacterGraphemeStream on: (AIUTF8DecodingStream on: byteArray readStream)))
]

{ #category : 'Not categorized' }
AIServerSentEventsStreamTest >> streamOnLineGroups: lineGroups [

	^ self streamOnString: (String streamContents: [ :stream |
		lineGroups do: [ :lineGroup |
			lineGroup do: [ :line |
				stream nextPutAll: line; nextPut: Character cr; nextPut: Character lf ].
			stream nextPut: Character cr; nextPut: Character lf ] ])
]

{ #category : 'Not categorized' }
AIServerSentEventsStreamTest >> streamOnString: string [

	^ self streamOnByteArray: string asUtf8Bytes
]

{ #category : 'Not categorized' }
AIServerSentEventsStreamTest >> test [

	| exampleByteArrayNonASCII exampleStringDataOnly |

	self assertStream: (self streamOnByteArray: #[]) readsEvents: #().
	self assertStream: (self streamOnByteArray: #[16r64 16r61 16r74 16r61 16r3A 16r31 16r0D 16r0A 16r64 16r61 16r74 16r61 16r3A 16r32 16r33 16r0A 16r0D]) readsEvents: {
		AIServerSentEvent type: 'message' data: '1' , String lf , '23' lastEventID: '' }.
	self assertStream: (self streamOnByteArray: (exampleByteArrayNonASCII := #[16r64 16r61 16r74 16r61 16r3A 16rF0 16r9F 16r98 16r80 16r0D 16r0D])) readsEvents: {
		AIServerSentEvent type: 'message' data: (UnicodeString escaped: '\u{1F600}') lastEventID: '' }.
	self assertStream: (self streamOnString: (exampleStringDataOnly := 'data: foo' , String lf , String lf)) readsEvents: {
		AIServerSentEvent type: 'message' data: 'foo' lastEventID: '' }.
	self assertStream: (self streamOnLineGroups: #((': test stream' '' 'data: first event' 'id: 1') ('data:second event' 'id') ('data:  third event'))) readsEvents: {
		AIServerSentEvent type: 'message' data: '' lastEventID: ''.
		AIServerSentEvent type: 'message' data: 'first event' lastEventID: '1'.
		AIServerSentEvent type: 'message' data: 'second event' lastEventID: ''.
		AIServerSentEvent type: 'message' data: ' third event' lastEventID: '' }.
	self assertStream: (self streamOnLineGroups: #(('event: report' 'data: first') ('info: field' 'data: second') ('retry: 100' 'data: third'))) readsEvents: {
		AIServerSentEvent type: 'report' data: 'first' lastEventID: ''.
		AIServerSentEvent type: 'message' data: 'second' lastEventID: ''.
		AIServerSentEvent type: 'message' data: 'third' lastEventID: '' }.
	self assertStream: (self streamOnLineGroups: #(('id: 42' 'data: 1') ('data: 2') ('id' 'data: 3'))) readsEvents: {
		AIServerSentEvent type: 'message' data: '1' lastEventID: '42'.
		AIServerSentEvent type: 'message' data: '2' lastEventID: '42'.
		AIServerSentEvent type: 'message' data: '3' lastEventID: '' }.
	self assertStream: (self streamOnLineGroups: #(('event: event1' 'data: data1' 'id: id1' 'event: event2' 'data: data2' 'id: id2'))) readsEvents: {
		AIServerSentEvent type: 'event2' data: 'data1' , String lf , 'data2' lastEventID: 'id2' }.
	self assertErrorWhenReadingStream: (self streamOnByteArray: (exampleByteArrayNonASCII copyWithout: 16r9F)).
	self assertErrorWhenReadingStream: (self streamOnString: (exampleStringDataOnly copyFrom: 1 to: exampleStringDataOnly size - 1)).
	self assertErrorWhenReadingStream: (self streamOnString: (exampleStringDataOnly copyFrom: 1 to: exampleStringDataOnly size - 2)).
]
