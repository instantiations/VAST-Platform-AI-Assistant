Class {
	#name : 'AIChatListPrompter',
	#superclass : 'CwListPrompter',
	#instVars : [
		'button3',
		'button3Name'
	],
	#category : 'AIAssistantUIApp'
}

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIChatListPrompter >> button3 [
	"Answer the button3 widget."

	^button3
]

{ #category : 'Internal',
  #vaVisibility : 'private' }
AIChatListPrompter >> button3: aWidget [
	"Set the button3 widget."

	button3 := aWidget
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIChatListPrompter >> button3: w clientData: clientData callData: callData [
	"Perform the callback processing for button3 activate."

	self result: #newChatWindow.
	self done: true
]

{ #category : 'Accessing' }
AIChatListPrompter >> button3Name [

	^button3Name
]

{ #category : 'Accessing' }
AIChatListPrompter >> button3Name: aString [

	button3Name := aString
]

{ #category : 'Accessing',
  #vaVisibility : 'private' }
AIChatListPrompter >> createChildren [
	"Create, initialize and manage the children of the bulletinBoardWidget.
	 We override this to add a third button and adjust the layout."

	| bb |
	super createChildren isNil ifTrue: [^nil].
	
	bb := self bulletinBoardWidget.
	
	self button3: ((bb createPushButton: self button3Name argBlock: [:w |
		w
			leftAttachment: XmATTACHPOSITION;
			leftPosition: 68;
			rightAttachment: XmATTACHFORM;
			bottomAttachment: XmATTACHFORM])) manageChild.

	self button1 setValuesBlock: [:w | 
		w 
			leftAttachment: XmATTACHFORM;
			rightAttachment: XmATTACHPOSITION; 
			rightPosition: 32].
			
	self button2 setValuesBlock: [:w | 
		w 
			leftAttachment: XmATTACHPOSITION; 
			leftPosition: 34; 
			rightAttachment: XmATTACHPOSITION; 
			rightPosition: 66].

	self button3
		addCallback: XmNactivateCallback
		receiver: self
		selector: #button3:clientData:callData:
		clientData: nil.
		
	^self
]
