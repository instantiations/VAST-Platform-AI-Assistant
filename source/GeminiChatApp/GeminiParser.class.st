Class {
	#name : 'GeminiParser',
	#superclass : 'EsParser',
	#instVars : [
		'errorExitBlock'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiParser class >> parse: code messagePattern: expectMessagePattern scanComments: shouldScanComments onError: errorBlock [

	^ self new parse: code messagePattern: expectMessagePattern scanComments: shouldScanComments onError: errorBlock
]

{ #category : 'Not categorized' }
GeminiParser >> fatalError: errorString sourcePosition: sourcePosition [

	errorExitBlock value: errorString value: sourcePosition
]

{ #category : 'Not categorized' }
GeminiParser >> parse: code messagePattern: expectMessagePattern scanComments: shouldScanComments onError: errorBlock [

	errorExitBlock := [ :errorString :sourcePosition | ^ errorBlock value: errorString value: sourcePosition ].
	^ self parseMethod: code messagePattern: expectMessagePattern scanComments: shouldScanComments
]
