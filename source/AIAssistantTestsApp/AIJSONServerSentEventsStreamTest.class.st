Class {
	#name : 'AIJSONServerSentEventsStreamTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Asserting' }
AIJSONServerSentEventsStreamTest >> assertStreamOnEventsWithData: dataArray readsJSONValues: expectedJSONValues [

	| jsonValuesStream actualJSONValues |

	jsonValuesStream := AIJSONServerSentEventsStream on: (dataArray collect: [ :data | AIServerSentEvent type: 'message' data: data lastEventID: '' ]) readStream.
	actualJSONValues := Array streamContents: [ :arrayStream | [ jsonValuesStream atEnd ] whileFalse: [ arrayStream nextPut: jsonValuesStream next ] ].
	self assert: actualJSONValues equals: expectedJSONValues.
]

{ #category : 'Tests' }
AIJSONServerSentEventsStreamTest >> test [

	self assertStreamOnEventsWithData: #()
		readsJSONValues: #().
	self assertStreamOnEventsWithData: #('[DONE]')
		readsJSONValues: #().
	self assertStreamOnEventsWithData: #('"[DONE]"')
		readsJSONValues: #('[DONE]').
	self assertStreamOnEventsWithData: #('"[DONE]"' '[DONE]')
		readsJSONValues: #('[DONE]').
	self assertStreamOnEventsWithData: #('"\u0080"')
		readsJSONValues: { UnicodeString escaped: '\u{80}' }.
	self assertStreamOnEventsWithData: #('"\u20DD"')
		readsJSONValues: { UnicodeString escaped: '\u{20DD}' }.
	self assertStreamOnEventsWithData: { UnicodeString escaped: '"\u{20DD}"' }
		readsJSONValues: { UnicodeString escaped: '\u{20DD}' }.
]
