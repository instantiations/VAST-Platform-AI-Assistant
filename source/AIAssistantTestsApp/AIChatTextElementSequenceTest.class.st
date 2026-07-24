Class {
	#name : 'AIChatTextElementSequenceTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Not categorized' }
AIChatTextElementSequenceTest >> assertElementSequenceFromString: string hasElements: textElements [

	self assert: (AIChatTextElementSequence fromString: string) equals: (AIChatTextElementSequence elements: (OrderedCollection withAll: textElements))
]

{ #category : 'Not categorized' }
AIChatTextElementSequenceTest >> testFromString [

	self assertElementSequenceFromString: 'Text' hasElements: {
		AIChatTextElementString string: 'Text' }.
	self assertElementSequenceFromString: '*Italic*' hasElements: {
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence fromString: 'Italic') }.
	self assertElementSequenceFromString: '**Bold**' hasElements: {
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence fromString: 'Bold') }.
	self assertElementSequenceFromString: '`1 + 2`' hasElements: {
		AIChatTextElementCode code: '1 + 2' }.
	self assertElementSequenceFromString: '[Instantiations](https://www.instantiations.com)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'Instantiations') destination: 'https://www.instantiations.com' }.

	self assertElementSequenceFromString: '*This is **bold** text*' hasElements: {
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence elements: (OrderedCollection withAll: {
			AIChatTextElementString string: 'This is '.
			AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence fromString: 'bold').
			AIChatTextElementString string: ' text' })) }.
	self assertElementSequenceFromString: '**This is *italic* text**' hasElements: {
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence elements: (OrderedCollection withAll: {
			AIChatTextElementString string: 'This is '.
			AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence fromString: 'italic').
			AIChatTextElementString string: ' text' })) }.
	self assertElementSequenceFromString: '**[link](url)**' hasElements: {
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence elements: (OrderedCollection withAll: {
			AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'link') destination: 'url' })) }.
	self assertElementSequenceFromString: '*[link](url)*' hasElements: {
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence elements: (OrderedCollection withAll: {
			AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'link') destination: 'url' })) }.

	self assertElementSequenceFromString: '**Foo****Bar**' hasElements: {
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence elements: (OrderedCollection withAll: {
			AIChatTextElementString string: 'Foo'.
			AIChatTextElementString string: '****'.
			AIChatTextElementString string: 'Bar' })) }.
	self assertElementSequenceFromString: '*Foo***Bar***' hasElements: {
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence fromString: 'Foo').
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence fromString: 'Bar').
		AIChatTextElementString string: '*'}.
		
	self assertElementSequenceFromString: '*This is not italic' hasElements: {
		AIChatTextElementString string: '*'.
		AIChatTextElementString string: 'This is not italic' }.
	self assertElementSequenceFromString: '**This is not bold' hasElements: {
		AIChatTextElementString string: '**'.
		AIChatTextElementString string: 'This is not bold' }.
	self assertElementSequenceFromString: '[unclosed link' hasElements: {
		AIChatTextElementString string: '['.
		AIChatTextElementString string: 'unclosed link' }.
	self assertElementSequenceFromString: 'This is a string with a * in the middle.' hasElements: {
		AIChatTextElementString string: 'This is a string with a '.
		AIChatTextElementString string: '*'.
		AIChatTextElementString string: ' in the middle.' }.
	self assertElementSequenceFromString: 'This string has a [ but no link.' hasElements: {
		AIChatTextElementString string: 'This string has a '.
		AIChatTextElementString string: '['.
		AIChatTextElementString string: ' but no link.' }.

	self assertElementSequenceFromString: '[](url)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: '') destination: 'url' }.
	self assertElementSequenceFromString: '[text]()' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'text') destination: '' }.
	self assertElementSequenceFromString: '[[Nested] text](url)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: '[Nested] text') destination: 'url' }.

	self assertElementSequenceFromString: '``' hasElements: { AIChatTextElementString string: '``' }.
	self assertElementSequenceFromString: '`` ` ``' hasElements: { AIChatTextElementCode code: '`' }.

	self assertElementSequenceFromString: 'This is **bold** and *italic* and a [link](url) and some `code`.' hasElements: {
		AIChatTextElementString string: 'This is '.
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence fromString: 'bold').
		AIChatTextElementString string: ' and '.
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence fromString: 'italic').
		AIChatTextElementString string: ' and a '.
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'link') destination: 'url'.
		AIChatTextElementString string: ' and some '.
		AIChatTextElementCode code: 'code'.
		AIChatTextElementString string: '.' }.
]
