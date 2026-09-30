Class {
	#name : 'AIChatGenerationLogTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatGenerationLogTest >> createGeneratedContentLogEntryWithUserMessage: userMessage [

	^ self createGeneratedContentLogEntryWithUserMessage: userMessage modelMessage: ''
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatGenerationLogTest >> createGeneratedContentLogEntryWithUserMessage: userMessage modelMessage: modelMessage [

	^ AIChatGenerationLogEntryGeneratedContent timestamp: DateAndTime now model: nil
		requestObject: (EsOrderedDictionary with: 'user' copy -> userMessage)
		responseHeader: nil
		responseObjects: (OrderedCollection with: (EsOrderedDictionary with: 'model' copy -> modelMessage))
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatGenerationLogTest >> createGeneratedContentLogEntryWithUserMessageOfSize: size [

	^ self createGeneratedContentLogEntryWithUserMessage: (String new: size withAll: $?)
]

{ #category : 'Tests' }
AIChatGenerationLogTest >> test [

	| sizeLimit log entry1 entry1Size entry2 entry3 emptyStringEntrySizeIncrease largeString entry4 entry5 largeUnicodeString entry6 entry7 |

	sizeLimit := 50000.
	log := AIChatGenerationLog sizeLimit: sizeLimit.
	self assert: log entries isEmpty.
	self assert: log totalSize equals: 0.

	entry1 := self createGeneratedContentLogEntryWithUserMessage: 'User message 1' modelMessage: 'Model message 1'.
	entry1Size := self totalSizeDifferenceAfterAdding: entry1 to: log.
	self assert: log entries size equals: 1.
	self assert: log entries first == entry1.
	self assert: entry1Size > 0.

	entry2 := self createGeneratedContentLogEntryWithUserMessage: 'User message 2' modelMessage: 'Model message 2'.
	self assert: (self totalSizeDifferenceAfterAdding: entry2 to: log) equals: entry1Size.
	self assert: log entries size equals: 2.
	self assert: log entries last == entry2.

	entry3 := self createGeneratedContentLogEntryWithUserMessage: ''.
	emptyStringEntrySizeIncrease := self totalSizeDifferenceAfterAdding: entry3 to: log.

	largeString := String new: 10000 withAll: $?.
	entry4 := self createGeneratedContentLogEntryWithUserMessage: largeString.
	self assert: (self totalSizeDifferenceAfterAdding: entry4 to: log) >= largeString size.

	entry5 := self createGeneratedContentLogEntryWithUserMessage: largeString.
	self assert: (self totalSizeDifferenceAfterAdding: entry5 to: log) <= emptyStringEntrySizeIncrease.

	largeUnicodeString := UnicodeString new: 10000 withAll: $?.
	entry6 := self createGeneratedContentLogEntryWithUserMessage: largeUnicodeString.
	self assert: (self totalSizeDifferenceAfterAdding: entry6 to: log) >= largeUnicodeString size.

	entry7 := self createGeneratedContentLogEntryWithUserMessage: largeUnicodeString.
	self assert: (self totalSizeDifferenceAfterAdding: entry7 to: log) <= emptyStringEntrySizeIncrease.

	{ entry2. entry3. entry4 } do: [ :entry |
		log addEntry: (self createGeneratedContentLogEntryWithUserMessageOfSize: (sizeLimit - log totalSize - (entry1Size - emptyStringEntrySizeIncrease) max: 0)).
		self assert: log entries first == entry ].

	log addEntry: (self createGeneratedContentLogEntryWithUserMessageOfSize: sizeLimit - log totalSize).
	self assert: log entries first == entry6.

	log addEntry: (self createGeneratedContentLogEntryWithUserMessageOfSize: sizeLimit).
	self assert: log entries isEmpty.
	self assert: log totalSize equals: 0.
]

{ #category : 'Private',
  #vaVisibility : 'private' }
AIChatGenerationLogTest >> totalSizeDifferenceAfterAdding: entry to: log [

	| totalSizeBefore |

	totalSizeBefore := log totalSize.
	log addEntry: entry.
	^ log totalSize - totalSizeBefore
]
