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
AIChatTextElementSequenceTest >> assertFormattedStringIsEquivalentForElementSequenceFromString: string [

	| textElementSequence1 formattedString textElementSequence2 |

	textElementSequence1 := AIChatTextElementSequence fromString: string.
	formattedString := String streamContents: [ :stream | textElementSequence1 writeFormattedOn: stream ].
	textElementSequence2 := AIChatTextElementSequence fromString: formattedString.

	self assert: textElementSequence2 equals: textElementSequence1
]

{ #category : 'Not categorized' }
AIChatTextElementSequenceTest >> testFromString [

	| combiningEnclosingCircle |

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

	self assertElementSequenceFromString: '\Text' hasElements: {
		AIChatTextElementString string: '\Text' }.
	self assertElementSequenceFromString: '\T\e\x\t' hasElements: {
		AIChatTextElementString string: '\T\e\x\t' }.
	self assertElementSequenceFromString: '\\Text' hasElements: {
		AIChatTextElementString string: '\Text' }.
	self assertElementSequenceFromString: 'Text\' hasElements: {
		AIChatTextElementString string: 'Text\' }.
	self assertElementSequenceFromString: 'Text\*' hasElements: {
		AIChatTextElementString string: 'Text*' }.
	self assertElementSequenceFromString: 'Text\*\*' hasElements: {
		AIChatTextElementString string: 'Text**' }.
	self assertElementSequenceFromString: '\ \' hasElements: {
		AIChatTextElementString string: '\ \' }.
	self assertElementSequenceFromString: '\!\"\#\$\%\&\''\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~' hasElements: {
		AIChatTextElementString string: '!"#$%&''()*+,-./:;<=>?@[\]^_`{|}~' }.

	self assertElementSequenceFromString: '\\*Italic*' hasElements: {
		AIChatTextElementString string: '\'.
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence fromString: 'Italic') }.
	self assertElementSequenceFromString: '**Bold\\**' hasElements: {
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence fromString: 'Bold\\') }.

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
			AIChatTextElementString string: 'Foo****Bar' })) }.
	self assertElementSequenceFromString: '*Foo***Bar***' hasElements: {
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence fromString: 'Foo').
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence fromString: 'Bar').
		AIChatTextElementString string: '*'}.
		
	self assertElementSequenceFromString: '*This is not italic' hasElements: {
		AIChatTextElementString string: '*This is not italic' }.
	self assertElementSequenceFromString: '\*This is not italic*' hasElements: {
		AIChatTextElementString string: '*This is not italic*' }.
	self assertElementSequenceFromString: '*This is not italic\*' hasElements: {
		AIChatTextElementString string: '*This is not italic*' }.
	self assertElementSequenceFromString: '**This is not bold' hasElements: {
		AIChatTextElementString string: '**This is not bold' }.
	self assertElementSequenceFromString: '\*\*This is not bold**' hasElements: {
		AIChatTextElementString string: '**This is not bold**' }.
	self assertElementSequenceFromString: '**This is not bold\*\*' hasElements: {
		AIChatTextElementString string: '**This is not bold**' }.
	self assertElementSequenceFromString: '[unclosed link' hasElements: {
		AIChatTextElementString string: '[unclosed link' }.
	self assertElementSequenceFromString: '\[not a link](url)' hasElements: {
		AIChatTextElementString string: '[not a link](url)' }.
	self assertElementSequenceFromString: '[not a link\](url)' hasElements: {
		AIChatTextElementString string: '[not a link](url)' }.
	self assertElementSequenceFromString: '[not a link](url\)' hasElements: {
		AIChatTextElementString string: '[not a link](url)' }.
	self assertElementSequenceFromString: '[not a link](url\\\)' hasElements: {
		AIChatTextElementString string: '[not a link](url\)' }.
	self assertElementSequenceFromString: 'This is a string with a * in the middle.' hasElements: {
		AIChatTextElementString string: 'This is a string with a * in the middle.' }.
	self assertElementSequenceFromString: 'This string has a [ but no link.' hasElements: {
		AIChatTextElementString string: 'This string has a [ but no link.' }.
	self assertElementSequenceFromString: '\`not code`' hasElements: {
		AIChatTextElementString string: '`not code`' }.

	self assertElementSequenceFromString: '[](url)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: '') destination: 'url' }.
	self assertElementSequenceFromString: '[text]()' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'text') destination: '' }.
	self assertElementSequenceFromString: '[[Nested] text](url)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: '[Nested] text') destination: 'url' }.
	self assertElementSequenceFromString: '[text\\](url)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'text\\') destination: 'url' }.
	self assertElementSequenceFromString: '[text\]](url)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'text\]') destination: 'url' }.
	self assertElementSequenceFromString: '[text](\(\u\r\l\))' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'text') destination: '(\u\r\l)' }.
	self assertElementSequenceFromString: '[text](url\\)' hasElements: {
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: 'text') destination: 'url\' }.

	self assertElementSequenceFromString: '``' hasElements: { AIChatTextElementString string: '``' }.
	self assertElementSequenceFromString: '`` ` ``' hasElements: { AIChatTextElementCode code: '`' }.
	self assertElementSequenceFromString: '```' hasElements: { AIChatTextElementString string: '```' }.
	self assertElementSequenceFromString: '````' hasElements: { AIChatTextElementString string: '````' }.
	self assertElementSequenceFromString: '```foo``' hasElements: { AIChatTextElementString string: '```foo``' }.
	self assertElementSequenceFromString: '`foo``bar`' hasElements: { AIChatTextElementCode code: 'foo``bar' }.
	self assertElementSequenceFromString: '`\x`' hasElements: { AIChatTextElementCode code: '\x' }.
	self assertElementSequenceFromString: '`\*`' hasElements: { AIChatTextElementCode code: '\*' }.
	self assertElementSequenceFromString: '`\\`' hasElements: { AIChatTextElementCode code: '\\' }.
	self assertElementSequenceFromString: '`\`' hasElements: { AIChatTextElementCode code: '\' }.

	combiningEnclosingCircle := UnicodeString escaped: '\u{20DD}'.
	self assertElementSequenceFromString: ('%1*%1*%1' bindWith: combiningEnclosingCircle) hasElements: {
		AIChatTextElementString string: combiningEnclosingCircle.
		AIChatTextElementEmphasis isStrong: false element: (AIChatTextElementSequence fromString: combiningEnclosingCircle).
		AIChatTextElementString string: combiningEnclosingCircle }.
	self assertElementSequenceFromString: ('%1**%1**%1' bindWith: combiningEnclosingCircle) hasElements: {
		AIChatTextElementString string: combiningEnclosingCircle.
		AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementSequence fromString: combiningEnclosingCircle).
		AIChatTextElementString string: combiningEnclosingCircle }.
	self assertElementSequenceFromString: ('%1`%1`%1' bindWith: combiningEnclosingCircle) hasElements: {
		AIChatTextElementString string: combiningEnclosingCircle.
		AIChatTextElementCode code: combiningEnclosingCircle.
		AIChatTextElementString string: combiningEnclosingCircle }.
	self assertElementSequenceFromString: ('%1[%1](%1)%1' bindWith: combiningEnclosingCircle) hasElements: {
		AIChatTextElementString string: combiningEnclosingCircle.
		AIChatTextElementLink element: (AIChatTextElementSequence fromString: combiningEnclosingCircle) destination: combiningEnclosingCircle.
		AIChatTextElementString string: combiningEnclosingCircle }.
	self assertElementSequenceFromString: ('%1\%1' bindWith: combiningEnclosingCircle) hasElements: {
		AIChatTextElementString string: ('%1\%1' bindWith: combiningEnclosingCircle) }.

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

{ #category : 'Not categorized' }
AIChatTextElementSequenceTest >> testWriteFormattedOn [

	self assertFormattedStringIsEquivalentForElementSequenceFromString: 'Text'.

	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\\Text'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: 'Text\'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\T\e\x\t'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\*Text\*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\*Text*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '*Text\*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '*Text'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: 'Text*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\*\*Text\*\*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\*\*Text**'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '**Text\*\*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '**Text'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: 'Text**'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\`Text\`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\`Text`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`Text'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: 'Text`'.

	self assertFormattedStringIsEquivalentForElementSequenceFromString: '*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '**'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '***`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '``'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '```'.

	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[foo'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\[foo](bar)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[foo\](bar)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[foo]\(bar)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[foo](bar\)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[foo](bar\\\)'.
	
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '\!\"\#\$\%\&\''\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~'.

	self assertFormattedStringIsEquivalentForElementSequenceFromString: '*Text*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '**Text**'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '***Text***'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '*Italic **bold** text*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '**Bold *italic* text**'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '*Italic**bold**text*'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '**Bold*italic*text**'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '*[Italic **bold** link](url)*'.

	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[](url)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[text]()'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[text](url)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[Instantiations](https://www.instantiations.com)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[[Nested] text](url)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[(text)](url)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[text\\](url)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[text\]](url)'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[text](\(\u\r\l\))'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '[text](url\\)'.

	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`1 + 2`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '` 1 + 2 `'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '` 1 + 2`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`1 + 2 `'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '``1 + 2``'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '` `'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`  `'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`` ` ``'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`` `foo ``'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`` foo` ``'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`` `foo` ``'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`` ` foo ` ``'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '``` ``foo`bar`` ```'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`\`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`\\`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`\x`'.
	self assertFormattedStringIsEquivalentForElementSequenceFromString: '`\*`'.
]
