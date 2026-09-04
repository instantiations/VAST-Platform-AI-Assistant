Extension {
	#name : 'AIChatTextElementCode'
}

{ #category : 'Widget Event Handling' }
AIChatTextElementCode >> buttonPressedIn: chatWidget [

	self referencedMethod ifNotNil: [ :method |
		| classToBrowse |
		classToBrowse := method methodClass.
		classToBrowse isMetaclass ifTrue: [ classToBrowse := classToBrowse primaryInstance ].
		CwAppContext default asyncExecInUI: [
			((EtTools browser: #classes) on: classToBrowse)
				owningImage: System image;
				selectedClasses: (Array with: classToBrowse);
				open;
				ifNotNil: [ :browser |
					method methodClass isMetaclass ifTrue: [ browser methodInstanceButtonSelected: nil ].
					(browser showingPublicMethods xor: method isPublic) ifTrue: [ browser methodPublicButtonSelected: nil ].
					browser updateApplications: (method application ifNil: [ #() ] ifNotNil: [ Array with: method application ]) restoreToTop: false.
					browser updateCategories: (method methodClass categoriesFor: method selector) restoreToTop: false.
					browser updateMethods: (Array with: method) restoreToTop: false ] ].
		^ self ].

	self referencedClass ifNotNil: [ :referencedClass |
		CwAppContext default asyncExecInUI: [
			((EtTools browser: #classes) on: referencedClass)
				owningImage: System image;
				selectedClasses: (Array with: referencedClass);
				open ] ]
]

{ #category : 'Drawing' }
AIChatTextElementCode >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementCode: self dc: dc
]

{ #category : 'Widget Event Handling' }
AIChatTextElementCode >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Widget Event Handling' }
AIChatTextElementCode >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Accessing' }
AIChatTextElementCode >> referencedClass [

	^ (self code notEmpty and: [ self code first isUppercase and: [ self code isSmalltalkIdentifier ] ])
		ifTrue: [ Smalltalk classAt: self code asEsString ]
]

{ #category : 'Accessing' }
AIChatTextElementCode >> referencedMethod [

	| parts className isMeta selector class |
	parts := '>>' split: self code.
	parts size = 2 ifFalse: [ ^ nil ].
	className := parts first trimBlanks.
	selector := parts second trimBlanks.
	isMeta := className endsWithSubCollection: ' class'.
	isMeta ifTrue: [ className := (className copyFrom: 1 to: className size - 6) trimBlanks ].
	class := Smalltalk classAt: className asEsString.
	class ifNil: [ ^ nil ].
	class := isMeta ifTrue: [ class class ] ifFalse: [ class ].
	^ class compiledMethodAt: selector asSymbol ifAbsent: [ nil ]
]

{ #category : 'Testing' }
AIChatTextElementCode >> referencesClass [

	^ self referencedClass notNil
]

{ #category : 'Testing' }
AIChatTextElementCode >> referencesMethod [

	^ self referencedMethod notNil
]

{ #category : 'Drawing' }
AIChatTextElementCode >> resetLayout [

	self codeTextString resetLayout
]

{ #category : 'Writing' }
AIChatTextElementCode >> writeFormattedOn: stream [

	| numberOfTicks startIndexTicks delimiter startsOrEndsWithTick |

	numberOfTicks := 1.
	startIndexTicks := nil.
	self code keysAndValuesDo: [ :index :character |
		character = $` ifTrue: [
			startIndexTicks ifNil: [
				startIndexTicks := index ]
		] ifFalse: [
			startIndexTicks ifNotNil: [
				numberOfTicks := numberOfTicks max: (index - startIndexTicks + 1) ] ] ].
	startIndexTicks ifNotNil: [
		numberOfTicks := numberOfTicks max: (self code size + 1 - startIndexTicks + 1) ].
	
	delimiter := String new: numberOfTicks withAll: $`.
	startsOrEndsWithTick := self code notEmpty and: [ self code first = $` or: [ self code last = $` ] ].
	
	stream nextPutAll: delimiter.
	startsOrEndsWithTick ifTrue: [
		stream nextPut: Character space ].
	stream nextPutAll: self code.
	startsOrEndsWithTick ifTrue: [
		stream nextPut: Character space ].
	stream nextPutAll: delimiter.
]
