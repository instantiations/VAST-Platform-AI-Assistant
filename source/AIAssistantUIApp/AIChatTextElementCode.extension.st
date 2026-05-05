Extension {
	#name : 'AIChatTextElementCode'
}

{ #category : 'Not categorized' }
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

{ #category : 'Not categorized' }
AIChatTextElementCode >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementCode: self dc: dc
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> referencedClass [

	^ (self code notEmpty and: [ self code first isUppercase and: [ self code isSmalltalkIdentifier ] ])
		ifTrue: [ Smalltalk classAt: self code asEsString ]
]

{ #category : 'Not categorized' }
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

{ #category : 'Not categorized' }
AIChatTextElementCode >> referencesClass [

	^ self referencedClass notNil
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> referencesMethod [

	^ self referencedMethod notNil
]

{ #category : 'Not categorized' }
AIChatTextElementCode >> resetLayout [

	self codeTextString resetLayout
]
