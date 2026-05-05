Class {
	#name : 'AIJSONWriter',
	#superclass : 'NeoJSONWriter',
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIJSONWriter >> writeString: string [
	writeStream nextPut: $".
	string do: [ :char |
		self encodeChar: char ].
	writeStream nextPut: $"
]
