"
A CollateEntry holds both the sequence for a codepoint, and a map of the valid combinations with other characters that form different collate sequences/entries.

Users are responsible for resolving CollateEntries that are not to be further combined into CollateSequences, by calling #value.


"
Class {
	#name : #CollateEntry,
	#superclass : #Object,
	#instVars : [
		'sequence',
		'combinations'
	],
	#category : #'Unicode-Collate'
}

{ #category : #accessing }
CollateEntry >> followedBy: aCodePoint [
	^combinations at: aCodePoint ifAbsent: [ nil ]
]

{ #category : #accessing }
CollateEntry >> followedBy: aCodePoint ifAbsent: aBlock [
	^combinations at: aCodePoint ifAbsent: aBlock
]

{ #category : #accessing }
CollateEntry >> followedBy: aCodePoint ifAbsentPut: anEntry [ 
	"Use IdentityDictionary over normal Dictionary due to better hash distribution of identityHash"
	^(combinations ifNil: [combinations := IdentityDictionary new]) at: aCodePoint ifAbsentPut: anEntry
]

{ #category : #private }
CollateEntry >> minimize [
	"Return the minimal representation of me; if I have no combinations this is simply the sequence.
	If I have few combinations, use a linearly probed dictionary instead.
	If not, use the standard IdentityDictionary.
	We can use IdentityDictionary/SmallDictionaries interchangeably here, since the keys are all SmallIntegers with value-based identity equality"

	combinations ifNil: [ ^ sequence ].
	combinations size <= 10 ifTrue: 
		[ combinations := SmallDictionary withAll: combinations ].
	combinations keysAndValuesDo: [:codePoint :entry | 		combinations at: codePoint put: entry minimize]
]

{ #category : #printing }
CollateEntry >> printOn: aStream [
	sequence 
		ifNil: [^super printOn: aStream]
		ifNotNil: [ sequence printOn: aStream ].
	combinations ifNotNil: [ aStream nextPutAll: '+++' ]
]

{ #category : #private }
CollateEntry >> setSequence: aSequence [
	sequence := aSequence
]

{ #category : #accessing }
CollateEntry >> value [
	^sequence
]