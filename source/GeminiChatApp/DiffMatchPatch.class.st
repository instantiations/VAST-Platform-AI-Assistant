Class {
	#name : 'DiffMatchPatch',
	#superclass : 'Object',
	#category : 'GeminiChatApp'
}

{ #category : 'Not categorized' }
DiffMatchPatch >> backtrackTrace: trace text1: text1 text2: text2 [
	| x y max diffs d k kIndex prevK prevKIndex prevX prevY |
	x := text1 size.
	y := text2 size.
	max := x + y.
	diffs := OrderedCollection new.
	
	d := trace size - 2.
	
	[x > 0 or: [y > 0]] whileTrue: [
		| v |
		v := trace at: d + 1. 
		k := x - y.
		kIndex := k + max + 1.
		
		(k = (0 - d) or: [k ~= d and: [(v at: kIndex - 1) < (v at: kIndex + 1)]])
			ifTrue: [
				prevK := k + 1.
			]
			ifFalse: [
				prevK := k - 1.
			].
		
		prevKIndex := prevK + max + 1.
		prevX := v at: prevKIndex.
		prevY := prevX - prevK.
		
		[x > prevX and: [y > prevY]] whileTrue: [
			diffs addFirst: (DiffOperation operation: #equal text: (text1 copyFrom: x to: x)).
			x := x - 1.
			y := y - 1.
		].
		
		d > 0 ifTrue: [
			x = prevX ifTrue: [
				diffs addFirst: (DiffOperation operation: #insert text: (text2 copyFrom: y to: y)).
				y := y - 1.
			] ifFalse: [
				diffs addFirst: (DiffOperation operation: #delete text: (text1 copyFrom: x to: x)).
				x := x - 1.
			].
		].
		d := d - 1.
	].
	
	^self cleanupMerge: diffs
]

{ #category : 'Not categorized' }
DiffMatchPatch >> cleanupMerge: diffs [
	| merged current |
	diffs isEmpty ifTrue: [^diffs].
	merged := OrderedCollection new.
	current := diffs first.
	
	2 to: diffs size do: [:i |
		| next |
		next := diffs at: i.
		current operation == next operation
			ifTrue: [
				current := DiffOperation 
					operation: current operation 
					text: current text , next text.
			]
			ifFalse: [
				merged add: current.
				current := next.
			].
	].
	merged add: current.
	^merged
]

{ #category : 'Not categorized' }
DiffMatchPatch >> cleanupSemantic: thediffs [
	"Reduce the number of edits by shifting boundaries and merging tiny edits 
	 into larger, more human-readable blocks."
	
	| diffPointer diffs |
	thediffs isEmpty ifTrue: [^thediffs].
	diffs := thediffs.
	diffPointer := 1.
	
	[diffPointer <= diffs size] whileTrue: [
		| op1 op2 op3 |
		op1 := diffs at: diffPointer.
		
		"Look for #equal followed by #delete and #insert, or #insert and #delete"
		(diffPointer + 2 <= diffs size) ifTrue: [
			op2 := diffs at: diffPointer + 1.
			op3 := diffs at: diffPointer + 2.
			
			((op1 operation == #equal) and: 
			 [op2 operation ~= #equal and: 
			 [op3 operation ~= #equal and: 
			 [op2 operation ~= op3 operation]]]) ifTrue: [
				
				| lengthOfOverlap overlapDelete overlapInsert textInsert textDelete |
				textDelete := op2 operation == #delete ifTrue: [op2 text] ifFalse: [op3 text].
				textInsert := op2 operation == #insert ifTrue: [op2 text] ifFalse: [op3 text].
				
				"Calculate overlap between the #equal and the edits using prefix, not suffix!"
				lengthOfOverlap := self commonPrefixLengthOf: op1 text and: textDelete.
				lengthOfOverlap := lengthOfOverlap min: (self commonPrefixLengthOf: op1 text and: textInsert).
				
				lengthOfOverlap > 0 ifTrue: [
					| newOp1Text newDeleteText newInsertText newDiffs |
					overlapDelete := textDelete copyFrom: 1 to: lengthOfOverlap.
					overlapInsert := textInsert copyFrom: 1 to: lengthOfOverlap.
					
					newOp1Text := op1 text copyFrom: lengthOfOverlap + 1 to: op1 text size.
					newDeleteText := textDelete copyFrom: lengthOfOverlap + 1 to: textDelete size.
					newInsertText := textInsert copyFrom: lengthOfOverlap + 1 to: textInsert size.
					
					"Pre-append the overlap to the edits"
					newDeleteText := overlapDelete, newDeleteText.
					newInsertText := overlapInsert, newInsertText.
					
					newDiffs := OrderedCollection new.
					1 to: diffPointer - 1 do: [:i | newDiffs add: (diffs at: i)].
					
					newDeleteText isEmpty ifFalse: [
						newDiffs add: (DiffOperation operation: #delete text: newDeleteText).
					].
					
					newInsertText isEmpty ifFalse: [
						newDiffs add: (DiffOperation operation: #insert text: newInsertText).
					].
					
					"The remaining equal text is moved AFTER the edits"
					newOp1Text isEmpty ifFalse: [
						newDiffs add: (DiffOperation operation: #equal text: newOp1Text)
					].
					
					diffPointer + 3 to: diffs size do: [:i | newDiffs add: (diffs at: i)].
					diffs := self cleanupMerge: newDiffs.
					
					"Step back to re-evaluate"
					diffPointer := (diffPointer - 1) max: 1.
				] ifFalse: [
					diffPointer := diffPointer + 1.
				].
			] ifFalse: [
				diffPointer := diffPointer + 1.
			].
		] ifFalse: [
			diffPointer := diffPointer + 1.
		].
	].
	
	^diffs
]

{ #category : 'Not categorized' }
DiffMatchPatch >> commonPrefixLengthOf: text1 and: text2 [
	"Returns the length of the common prefix of two strings."
	| n max |
	max := text1 size min: text2 size.
	n := 0.
	[n < max and: [(text1 at: n + 1) = (text2 at: n + 1)]] whileTrue: [
		n := n + 1
	].
	^n
]

{ #category : 'Not categorized' }
DiffMatchPatch >> commonSuffixLengthOf: text1 and: text2 [
	"Returns the length of the common suffix of two strings."
	| n max size1 size2 |
	size1 := text1 size.
	size2 := text2 size.
	max := size1 min: size2.
	n := 0.
	[n < max and: [(text1 at: size1 - n) = (text2 at: size2 - n)]] whileTrue: [
		n := n + 1
	].
	^n
]

{ #category : 'Not categorized' }
DiffMatchPatch >> diffComputeText1: text1 text2: text2 [
	| diffs |
	diffs := OrderedCollection new.
	text1 isEmpty ifTrue: [
		text2 isEmpty ifFalse: [
			diffs add: (DiffOperation operation: #insert text: text2)
		].
		^diffs
	].
	text2 isEmpty ifTrue: [
		diffs add: (DiffOperation operation: #delete text: text1).
		^diffs
	].
	
	^self myersDiffText1: text1 text2: text2
]

{ #category : 'Not categorized' }
DiffMatchPatch >> diffMainText1: text1 text2: text2 [
	| prefixLen suffixLen prefix suffix str1 str2 diffs |
	text1 = text2 ifTrue: [
		text1 isEmpty ifFalse: [
			^OrderedCollection with: (DiffOperation operation: #equal text: text1)
		].
		^OrderedCollection new
	].
	
	prefixLen := self commonPrefixLengthOf: text1 and: text2.
	prefix := text1 copyFrom: 1 to: prefixLen.
	
	str1 := text1 copyFrom: prefixLen + 1 to: text1 size.
	str2 := text2 copyFrom: prefixLen + 1 to: text2 size.
	
	suffixLen := self commonSuffixLengthOf: str1 and: str2.
	suffix := str1 copyFrom: str1 size - suffixLen + 1 to: str1 size.
	
	str1 := str1 copyFrom: 1 to: str1 size - suffixLen.
	str2 := str2 copyFrom: 1 to: str2 size - suffixLen.
	
	diffs := self diffComputeText1: str1 text2: str2.
	
	"Restore prefix and suffix"
	prefix isEmpty ifFalse: [
		diffs addFirst: (DiffOperation operation: #equal text: prefix)
	].
	suffix isEmpty ifFalse: [
		diffs addLast: (DiffOperation operation: #equal text: suffix)
	].
	
	diffs := self cleanupMerge: diffs.
	^self cleanupSemantic: diffs
]

{ #category : 'Not categorized' }
DiffMatchPatch >> linesFrom: aString [
	"Splits a string into an array of lines, keeping the newline characters attached to each line."
	| lines start len char |
	lines := OrderedCollection new.
	start := 1.
	len := aString size.
	1 to: len do: [:i |
		char := aString at: i.
		(char = Character lf or: [char = Character cr and: [i = len or: [(aString at: i+1) ~= Character lf]]]) ifTrue: [
			lines add: (aString copyFrom: start to: i).
			start := i + 1.
		].
	].
	start <= len ifTrue: [
		lines add: (aString copyFrom: start to: len).
	].
	^lines asArray
]

{ #category : 'Not categorized' }
DiffMatchPatch >> myersDiffText1: text1 text2: text2 [
	| n m max v trace x y down |
	n := text1 size.
	m := text2 size.
	max := n + m.
	"Since Smalltalk arrays are 1-based, we offset the index by max + 1"
	v := Array new: max * 2 + 1.
	trace := OrderedCollection new.
	
	v at: max + 1 + 1 put: 0. "v[1] at k=0"
	
	0 to: max do: [:d |
		| currentV |
		currentV := v copy.
		trace add: currentV.
		
		(0 - d) to: d by: 2 do: [:k |
			| kIndex |
			kIndex := k + max + 1.
			
			(k = (0 - d) or: [k ~= d and: [(v at: kIndex - 1) < (v at: kIndex + 1)]])
				ifTrue: [
					x := v at: kIndex + 1.
					down := true.
				]
				ifFalse: [
					x := (v at: kIndex - 1) + 1.
					down := false.
				].
			y := x - k.
			
			[x < n and: [y < m and: [(text1 at: x + 1) = (text2 at: y + 1)]]] whileTrue: [
				x := x + 1.
				y := y + 1.
			].
			
			v at: kIndex put: x.
			
			(x >= n and: [y >= m]) ifTrue: [
				trace add: v copy.
				^self backtrackTrace: trace text1: text1 text2: text2
			]
		]
	].
	^OrderedCollection new
]

{ #category : 'Not categorized' }
DiffMatchPatch >> patienceDiffLines1: lines1 lines2: lines2 [
	| uniqueLines anchors diffs start1 start2 |
	uniqueLines := self uniqueLinesIn: lines1 and: lines2.
	
	"Filter the sequences down to just the unique lines to create anchors"
	anchors := self patienceLCSOf: (lines1 select: [:l | uniqueLines includes: l]) 
					and: (lines2 select: [:l | uniqueLines includes: l]).
	
	diffs := OrderedCollection new.
	start1 := 1.
	start2 := 1.
	
	anchors do: [:anchor |
		| i1 i2 gap1 gap2 gapDiffs |
		i1 := lines1 indexOf: anchor startingAt: start1.
		i2 := lines2 indexOf: anchor startingAt: start2.
		
		"1. Diff the gap BEFORE the anchor using Myers"
		(i1 > start1 or: [i2 > start2]) ifTrue: [
			gap1 := lines1 copyFrom: start1 to: i1 - 1.
			gap2 := lines2 copyFrom: start2 to: i2 - 1.
			gapDiffs := self myersDiffText1: gap1 text2: gap2.
			diffs addAll: gapDiffs.
		].
		
		"2. Add the anchor as a guaranteed #equal operation"
		diffs add: (DiffOperation operation: #equal text: (Array with: anchor)).
		
		start1 := i1 + 1.
		start2 := i2 + 1.
	].
	
	"3. Diff any remaining tail using Myers"
	(start1 <= lines1 size or: [start2 <= lines2 size]) ifTrue: [
		| tail1 tail2 tailDiffs |
		tail1 := lines1 copyFrom: start1 to: lines1 size.
		tail2 := lines2 copyFrom: start2 to: lines2 size.
		tailDiffs := self myersDiffText1: tail1 text2: tail2.
		diffs addAll: tailDiffs.
	].
	
	"4. Convert the Arrays of lines back to flat Strings for our renderer"
	diffs do: [:diff |
		| flatText |
		flatText := WriteStream on: String new.
		diff text do: [:lineStr | flatText nextPutAll: lineStr].
		diff operation: diff operation text: flatText contents.
	].
	
	^diffs
]

{ #category : 'Not categorized' }
DiffMatchPatch >> patienceLCSOf: seq1 and: seq2 [
	"Finds the Longest Common Subsequence of unique elements using Patience Sorting."
	| indices2 piles backPointers result |
	indices2 := Dictionary new.
	1 to: seq2 size do: [:i | indices2 at: (seq2 at: i) put: i].
	
	piles := OrderedCollection new.
	backPointers := Dictionary new.
	
	1 to: seq1 size do: [:i1 |
		| element i2 |
		element := seq1 at: i1.
		i2 := indices2 at: element ifAbsent: [nil].
		
		i2 notNil ifTrue: [
			| insertPileIndex |
			"Find the first pile whose top element has a larger i2"
			insertPileIndex := 1.
			[insertPileIndex <= piles size and: [((piles at: insertPileIndex) last at: 2) < i2]] whileTrue: [
				insertPileIndex := insertPileIndex + 1.
			].
			
			insertPileIndex > piles size ifTrue: [
				piles addLast: OrderedCollection new.
			].
			
			(piles at: insertPileIndex) addLast: (Array with: i1 with: i2).
			
			insertPileIndex > 1 ifTrue: [
				"Record the back-pointer to the top of the previous pile"
				backPointers at: i1 put: ((piles at: insertPileIndex - 1) last at: 1).
			].
		].
	].
	
	"Reconstruct the LCS by following the back-pointers from the top of the last pile"
	result := OrderedCollection new.
	piles isEmpty ifFalse: [
		| currentI1 |
		currentI1 := piles last last at: 1.
		[currentI1 notNil] whileTrue: [
			result addFirst: (seq1 at: currentI1).
			currentI1 := backPointers at: currentI1 ifAbsent: [nil].
		].
	].
	
	^result asArray
]

{ #category : 'Not categorized' }
DiffMatchPatch >> uniqueLinesIn: lines1 and: lines2 [
	"Finds lines that appear exactly once in lines1 and exactly once in lines2."
	| counts1 counts2 uniques |
	counts1 := Dictionary new.
	counts2 := Dictionary new.
	uniques := OrderedCollection new.
	
	"Count occurrences in lines1"
	lines1 do: [:line |
		counts1 at: line put: (counts1 at: line ifAbsent: [0]) + 1.
	].
	
	"Count occurrences in lines2"
	lines2 do: [:line |
		counts2 at: line put: (counts2 at: line ifAbsent: [0]) + 1.
	].
	
	"Collect lines that appear exactly once in BOTH"
	lines1 do: [:line |
		((counts1 at: line ifAbsent: [0]) = 1 and: [(counts2 at: line ifAbsent: [0]) = 1]) ifTrue: [
			uniques add: line.
		].
	].
	
	^uniques asArray
]
