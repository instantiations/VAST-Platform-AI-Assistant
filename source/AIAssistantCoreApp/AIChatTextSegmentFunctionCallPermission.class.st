Class {
	#name : 'AIChatTextSegmentFunctionCallPermission',
	#superclass : 'AIAbstractChatTextSegment',
	#instVars : [
		'functionCalls'
	],
	#category : 'AIAssistantCoreApp'
}

{ #category : 'Not categorized' }
AIChatTextSegmentFunctionCallPermission class >> forFunctionCall: functionCall block: block [

	^ self basicNew initializeWithTextBlocks: {
		AIChatTextBlockText text: (AIChatTextElementSequence elements: { AIChatTextElementEmphasis isStrong: true element: (AIChatTextElementString string: 'The model wants to call:') }).
		AIChatTextBlockText text: (AIChatTextElementSequence elements: { AIChatTextElementString string: functionCall displayString }).
		AIChatTextBlockText text: (AIChatTextElementSequence elements: {
			AIChatTextElementAction element: (AIChatTextElementString string: 'Allow') block: [ block value: true ].
			AIChatTextElementString string: ' '.
			AIChatTextElementAction element: (AIChatTextElementString string: 'Disallow') block: [ block value: false ] }) }
]
