Class {
	#name : 'AIDMPStringComparer',
	#superclass : 'Object',
	#instVars : [
		'string1',
		'string2',
		'equalRuns',
		'unEqualRuns',
		'currentRun',
		'insertedRuns',
		'deletedRuns',
		'leftPaddings',
		'rightPaddings',
		'insertedCharRuns',
		'deletedCharRuns'
	],
	#category : 'AIAssistantMergeViewApp'
}

{ #category : 'Actions' }
AIDMPStringComparer >> compare [

	| lineDiffs index1 index2 leftLine rightLine prevLeftLine prevRightLine gapDeleteStart
	  gapInsertStart |

	lineDiffs :=
		AIDiffMatchPatch new
			patienceDiffLines1: (AIDiffMatchPatch new linesFrom: string1)
			lines2: (AIDiffMatchPatch new linesFrom: string2).

	equalRuns := OrderedCollection new.
	unEqualRuns := OrderedCollection new.
	insertedRuns := OrderedCollection new.
	deletedRuns := OrderedCollection new.
	leftPaddings := Dictionary new.
	rightPaddings := Dictionary new.
	insertedCharRuns := OrderedCollection new.
	deletedCharRuns := OrderedCollection new.

	index1 := 1.
	index2 := 1.
	leftLine := 0.
	rightLine := 0.
	prevLeftLine := 0.
	prevRightLine := 0.

	gapDeleteStart := 1.
	gapInsertStart := 1.

	lineDiffs do: [:diff | | len newlines char |
		len := diff text size.
		newlines := 0.
		1 to: len do: [:i |
			char := diff text at: i.
			(char = Character lf
				or: [char = Character cr and: [i = len or: [(diff text at: i + 1) ~= Character lf]]])
					ifTrue: [newlines := newlines + 1]].

		diff isEqual
			ifTrue: [| leftDelta rightDelta |
				leftDelta := leftLine - prevLeftLine.
				rightDelta := rightLine - prevRightLine.

				leftDelta < rightDelta
					ifTrue: [
						leftPaddings
							at: (prevLeftLine max: 0)
							put:
								(leftPaddings at: (prevLeftLine max: 0) ifAbsent: [0]) +
									(rightDelta - leftDelta)].
				leftDelta > rightDelta
					ifTrue: [
						rightPaddings
							at: (prevRightLine max: 0)
							put:
								(rightPaddings at: (prevRightLine max: 0) ifAbsent: [0]) +
									(leftDelta - rightDelta)].

				(leftDelta > 0 or: [rightDelta > 0])
					ifTrue: [| dStr iStr intraDiffs dIndex iIndex |
						dStr := string1 copyFrom: gapDeleteStart to: index1 - 1.
						iStr := string2 copyFrom: gapInsertStart to: index2 - 1.

						intraDiffs := AIDiffMatchPatch new diffMainText1: dStr text2: iStr.

						dIndex := gapDeleteStart.
						iIndex := gapInsertStart.

						intraDiffs do: [:intra | | intraLen |
							intraLen := intra text size.
							intra isEqual
								ifTrue: [
									dIndex := dIndex + intraLen.
									iIndex := iIndex + intraLen].
							intra isDelete
								ifTrue: [
									deletedCharRuns add: (
										Array
											with: dIndex @ iIndex
											with: (dIndex + intraLen) @ iIndex).
									dIndex := dIndex + intraLen].
							intra isInsert
								ifTrue: [
									insertedCharRuns add: (
										Array
											with: dIndex @ iIndex
											with: dIndex @ (iIndex + intraLen)).
									iIndex := iIndex + intraLen]]].

				equalRuns add: (Array with: index1 @ index2 with: (index1 + len) @ (index2 + len)).
				index1 := index1 + len.
				index2 := index2 + len.
				leftLine := leftLine + newlines.
				rightLine := rightLine + newlines.
				prevLeftLine := leftLine.
				prevRightLine := rightLine.

				gapDeleteStart := index1.
				gapInsertStart := index2].
		diff isDelete
			ifTrue: [| run |
				run := Array with: index1 @ index2 with: (index1 + len) @ index2.
				unEqualRuns add: run.
				deletedRuns add: run.
				index1 := index1 + len.
				leftLine := leftLine + newlines].
		diff isInsert
			ifTrue: [| run |
				run := Array with: index1 @ index2 with: index1 @ (index2 + len).
				unEqualRuns add: run.
				insertedRuns add: run.
				index2 := index2 + len.
				rightLine := rightLine + newlines]].

	[| leftDelta rightDelta |
		leftDelta := leftLine - prevLeftLine.
		rightDelta := rightLine - prevRightLine.

		leftDelta < rightDelta
			ifTrue: [
				leftPaddings
					at: (prevLeftLine max: 0)
					put:
						(leftPaddings at: (prevLeftLine max: 0) ifAbsent: [0]) +
							(rightDelta - leftDelta)].
		leftDelta > rightDelta
			ifTrue: [
				rightPaddings
					at: (prevRightLine max: 0)
					put:
						(rightPaddings at: (prevRightLine max: 0) ifAbsent: [0]) +
							(leftDelta - rightDelta)].

		(leftDelta > 0 or: [rightDelta > 0])
			ifTrue: [| dStr iStr intraDiffs dIndex iIndex |
				dStr := string1 copyFrom: gapDeleteStart to: index1 - 1.
				iStr := string2 copyFrom: gapInsertStart to: index2 - 1.

				intraDiffs := AIDiffMatchPatch new diffMainText1: dStr text2: iStr.

				dIndex := gapDeleteStart.
				iIndex := gapInsertStart.

				intraDiffs do: [:intra | | intraLen |
					intraLen := intra text size.
					intra isEqual
						ifTrue: [
							dIndex := dIndex + intraLen.
							iIndex := iIndex + intraLen].
					intra isDelete
						ifTrue: [
							deletedCharRuns
								add: (Array with: dIndex @ iIndex with: (dIndex + intraLen) @ iIndex).
							dIndex := dIndex + intraLen].
					intra isInsert
						ifTrue: [
							insertedCharRuns
								add: (Array with: dIndex @ iIndex with: dIndex @ (iIndex + intraLen)).
							iIndex := iIndex + intraLen]]]]
								value.

	unEqualRuns := self mergeRuns: unEqualRuns.
	equalRuns := self mergeRuns: equalRuns.
	deletedRuns := self mergeRuns: deletedRuns.
	insertedRuns := self mergeRuns: insertedRuns.
	deletedCharRuns := self mergeRuns: deletedCharRuns.
	insertedCharRuns := self mergeRuns: insertedCharRuns.

	currentRun := 0
]

{ #category : 'Actions' }
AIDMPStringComparer >> convertRunToCharacterLocations: run [
	"Since our algorithm natively works in characters, we just return the run as-is!"
	^run
]

{ #category : 'Accessing' }
AIDMPStringComparer >> deletedCharRuns [
	^deletedCharRuns
]

{ #category : 'Accessing' }
AIDMPStringComparer >> deletedRuns [
	^deletedRuns
]

{ #category : 'Accessing' }
AIDMPStringComparer >> equalRuns [
	^equalRuns

]

{ #category : 'Accessing' }
AIDMPStringComparer >> insertedCharRuns [
	^insertedCharRuns
]

{ #category : 'Accessing' }
AIDMPStringComparer >> insertedRuns [
	^insertedRuns
]

{ #category : 'Accessing' }
AIDMPStringComparer >> leftPaddings [
	^leftPaddings
]

{ #category : 'Actions' }
AIDMPStringComparer >> mergeRuns: runsList [
	| merged current |
	runsList isEmpty ifTrue: [^runsList].
	merged := OrderedCollection new.
	current := runsList first.
	
	2 to: runsList size do: [:i |
		| next currentEnd nextStart |
		next := runsList at: i.
		currentEnd := current at: 2.
		nextStart := next at: 1.
		
		"If the end of the current run matches the start of the next run, merge them"
		(currentEnd x = nextStart x and: [currentEnd y = nextStart y])
			ifTrue: [
				current := Array with: (current at: 1) with: (next at: 2).
			]
			ifFalse: [
				merged add: current.
				current := next.
			].
	].
	merged add: current.
	^merged
]

{ #category : 'Accessing' }
AIDMPStringComparer >> rightPaddings [
	^rightPaddings
]

{ #category : 'Accessing' }
AIDMPStringComparer >> string1: aString [
	string1 := aString
]

{ #category : 'Accessing' }
AIDMPStringComparer >> string2: aString [
	string2 := aString
]

{ #category : 'Accessing' }
AIDMPStringComparer >> unEqualRuns [
	^unEqualRuns

]
