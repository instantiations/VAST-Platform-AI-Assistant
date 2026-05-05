Class {
	#name : 'AISmalltalkParser',
	#superclass : 'EsParser',
	#instVars : [
		'errorExitBlock'
	],
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Not categorized' }
AISmalltalkParser class >> parse: code messagePattern: expectMessagePattern scanComments: shouldScanComments onError: errorBlock [

	^ self new parse: code messagePattern: expectMessagePattern scanComments: shouldScanComments onError: errorBlock
]

{ #category : 'Not categorized' }
AISmalltalkParser >> fatalError: errorString sourcePosition: sourcePosition [

	errorExitBlock value: errorString value: sourcePosition
]

{ #category : 'Not categorized' }
AISmalltalkParser >> parse: code messagePattern: expectMessagePattern scanComments: shouldScanComments onError: errorBlock [

	errorExitBlock := [ :errorString :sourcePosition | ^ errorBlock value: errorString value: sourcePosition ].
	^ self parseMethod: code messagePattern: expectMessagePattern scanComments: shouldScanComments
]
