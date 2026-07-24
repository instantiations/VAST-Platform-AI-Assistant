Class {
	#name : 'AIUTF8DecodingStreamTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIUTF8DecodingStreamTest >> assertByteArray: byteArray decodesToScalarValues: expectedValues [

	| stream |

	stream := AIUTF8DecodingStream on: byteArray readStream.
	expectedValues do: [ :expectedValue |
		| next |
		self deny: stream atEnd.
		next := stream next.
		self assert: (next isKindOf: UnicodeScalar).
		self assert: next value equals: expectedValue ].
	self assert: stream atEnd.
	self assert: stream next isNil.
]

{ #category : 'Not categorized' }
AIUTF8DecodingStreamTest >> assertErrorWhenDecodingByteArray: byteArray [

	| stream |

	stream := AIUTF8DecodingStream on: byteArray readStream.
	self should: [ stream next ] raise: Error.

	stream := AIUTF8DecodingStream on: (#[16r21 16rC2 16rA1] , byteArray) readStream.
	self assert: stream next equals: (UnicodeScalar value: 16r21).
	self assert: stream next equals: (UnicodeScalar value: 16rA1).
	self should: [ stream next ] raise: Error.
]

{ #category : 'Not categorized' }
AIUTF8DecodingStreamTest >> test [

	"Empty byte sequence:"
	self assertByteArray: #[] decodesToScalarValues: #().

	"Byte sequences of different lengths encoding a single scalar:"
	self assertByteArray: #[16r21] decodesToScalarValues: #(16r21).
	self assertByteArray: #[16rC2 16rA1] decodesToScalarValues: #(16rA1).
	self assertByteArray: #[16rE2 16r80 16rBC] decodesToScalarValues: #(16r203C).
	self assertByteArray: #[16rF0 16r9F 16r98 16r8E] decodesToScalarValues: #(16r1F60E).

	"Byte sequences of different lengths encoding the minimum/maximum scalar for that length:"
	self assertByteArray: #[16r00] decodesToScalarValues: #(16r00).
	self assertByteArray: #[16r7F] decodesToScalarValues: #(16r7F).
	self assertByteArray: #[16rC2 16r80] decodesToScalarValues: #(16r80).
	self assertByteArray: #[16rDF 16rBF] decodesToScalarValues: #(16r7FF).
	self assertByteArray: #[16rE0 16rA0 16r80] decodesToScalarValues: #(16r800).
	self assertByteArray: #[16rEF 16rBF 16rBF] decodesToScalarValues: #(16rFFFF).
	self assertByteArray: #[16rF0 16r90 16r80 16r80] decodesToScalarValues: #(16r10000).
	self assertByteArray: #[16rF4 16r8F 16rBF 16rBF] decodesToScalarValues: #(16r10FFFF).

	"Multiple scalars with varying byte sequence lengths:"
	self assertByteArray: #[16rF0 16r9F 16r91 16r8D 16r20 16r4F 16r6B 16r20 16rF0 16r9F 16r98 16r80]
		decodesToScalarValues: #(16r1F44D 16r20 16r4F 16r6B 16r20 16r1F600).
	
	"Incomplete or malformed byte sequences:"
	self assertErrorWhenDecodingByteArray: #[16rC2].
	self assertErrorWhenDecodingByteArray: #[16rA1].
	self assertErrorWhenDecodingByteArray: #[16r80].
	self assertErrorWhenDecodingByteArray: #[16rE2 16r80].
	self assertErrorWhenDecodingByteArray: #[16rE2 16rBC].
	self assertErrorWhenDecodingByteArray: #[16r80 16r80].
	self assertErrorWhenDecodingByteArray: #[16rF0 16r9F 16r98].
	self assertErrorWhenDecodingByteArray: #[16r80 16r80 16r80].
	self assertErrorWhenDecodingByteArray: #[16r80 16r80 16r80 16r80].

	"Overlong encodings:"
	self assertErrorWhenDecodingByteArray: #[16rC0 16rA1].
	self assertErrorWhenDecodingByteArray: #[16rE0 16r80 16rA1].
	self assertErrorWhenDecodingByteArray: #[16rF0 16r80 16r80 16rA1].
	self assertErrorWhenDecodingByteArray: #[16rE0 16r82 16rA1].
	self assertErrorWhenDecodingByteArray: #[16rF0 16r80 16r82 16rA1].
	self assertErrorWhenDecodingByteArray: #[16rF0 16r82 16r80 16rBC].

	"Sequences corresponding to non-scalar values (surrogates or out of range):"
	self assertErrorWhenDecodingByteArray: #[16rED 16rA0 16r80].
	self assertErrorWhenDecodingByteArray: #[16rED 16rBF 16rBF].
	self assertErrorWhenDecodingByteArray: #[16rF4 16r90 16r80 16r80].
]
