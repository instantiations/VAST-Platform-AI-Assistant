Class {
	#name : 'GeminiChatAbstractProvider',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiChatAbstractProvider class >> all [

	| providers |

	providers := OrderedCollection new.
	self subclasses do: [ :subclass |
		providers addAll: subclass providers ].
	^ providers
]

{ #category : 'Not categorized' }
GeminiChatAbstractProvider >> models [

	self subclassResponsibility
]
