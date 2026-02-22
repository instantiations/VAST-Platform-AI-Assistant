Class {
	#name : 'GeminiUTF8DecodingStream',
	#superclass : 'Object',
	#instVars : [
		'stream'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiUTF8DecodingStream class >> on: stream [

	^ self basicNew initializeWithStream: stream
]

{ #category : 'Not categorized' }
GeminiUTF8DecodingStream >> atEnd [

	^ stream atEnd
]

{ #category : 'Not categorized' }
GeminiUTF8DecodingStream >> initializeWithStream: initialStream [

	self initialize.
	stream := initialStream.
]

{ #category : 'Not categorized' }
GeminiUTF8DecodingStream >> next [

	| byte |
	
	self atEnd ifTrue: [ ^ nil ].
	byte := stream next.
	^ (byte bitAt: 8) = 0
		ifTrue: [ UnicodeScalar codePoint: byte ]
		ifFalse: [
			| size byteArray |
			size := (byte bitAt: 6) = 0 ifTrue: [ 2 ] ifFalse: [ (byte bitAt: 5) = 0 ifTrue: [ 3 ] ifFalse: [ 4 ] ].
			(byteArray := ByteArray new: size)
				at: 1 put: byte.
			2 to: size do: [ :index |
				byteArray at: index put: stream next ].
			UnicodeScalar utf8: byteArray ]
]
