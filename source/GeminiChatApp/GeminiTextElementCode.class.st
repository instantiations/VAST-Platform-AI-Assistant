Class {
	#name : 'GeminiTextElementCode',
	#superclass : 'GeminiAbstractTextElement',
	#instVars : [
		'code',
		'isPointedTo'
	],
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
GeminiTextElementCode class >> code: code [

	^ self basicNew initializeWithCode: code
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> = object [

	^ self class = object class and: [ self code = object code ]
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> buttonPressedIn: chatWidget [

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
GeminiTextElementCode >> code [

	^ code
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> drawOnChatWidget: chatWidget dc: dc [

	^ chatWidget drawTextElementCode: self dc: dc
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> initializeWithCode: initialCode [

	self initialize.
	code := initialCode.
	isPointedTo := false.
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> isCodeElement [

	^ true
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> isPointedTo [

	^ isPointedTo
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> pointerEnteredIn: chatWidget [

	isPointedTo := true.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> pointerLeftIn: chatWidget [

	isPointedTo := false.
	chatWidget redraw.
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> referencedClass [

	^ (code notEmpty and: [ code first isUppercase and: [ code isSmalltalkIdentifier ] ])
		ifTrue: [ Smalltalk classAt: code asEsString ]
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> referencedMethod [

	| parts className isMeta selector class |
	parts := '>>' split: code.
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
GeminiTextElementCode >> referencesClass [

	^ self referencedClass notNil
]

{ #category : 'Not categorized' }
GeminiTextElementCode >> referencesMethod [

	^ self referencedMethod notNil
]
