Class {
	#name : 'GeminiJSONWriter',
	#superclass : 'NeoJSONWriter',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiJSONWriter >> writeString: string [
	writeStream nextPut: $".
	string do: [ :char |
		self encodeChar: char ].
	writeStream nextPut: $"
]
