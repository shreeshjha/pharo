"
I am the handle in the right bottom of windows used for resizing them.
"
Class {
	#name : #BottomRightGripMorph,
	#superclass : #CornerGripMorph,
	#category : #'Morphic-Widgets-Windows-Resizing'
}

{ #category : #'target resize' }
BottomRightGripMorph >> apply: delta [
	| oldBounds |
	oldBounds := target bounds.
	target
		bounds: (oldBounds origin corner: oldBounds corner + delta)
]

{ #category : #testing }
BottomRightGripMorph >> containsPoint: aPoint [
	"Answer true only if on edges."

	|w|
	^(super containsPoint: aPoint) and: [
		w := SystemWindow borderWidth.
		((self bounds translateBy: (w@w) negated)
			containsPoint: aPoint) not]
]

{ #category : #drawing }
BottomRightGripMorph >> drawOn: aCanvas [
	"Draw the grip on the given canvas."

	| dotBounds alphaCanvas windowBorderWidth dotBounds2 |

	self shouldDraw ifFalse: [^self].

	windowBorderWidth := SystemWindow borderWidth.
	alphaCanvas := aCanvas asAlphaBlendingCanvas: 0.7.
	"alphaCanvas
		frameRectangle: bounds color: Color blue."

	dotBounds := self bounds.
	dotBounds2 := dotBounds left: (dotBounds right - windowBorderWidth).
	dotBounds2 := dotBounds2 top: (dotBounds2 bottom - windowBorderWidth).
	alphaCanvas
		fillRectangle: dotBounds2
		color: self handleColor.

	dotBounds2 := dotBounds right: (dotBounds right - windowBorderWidth).
	dotBounds2 := dotBounds2 top: (dotBounds2 bottom - windowBorderWidth).
	alphaCanvas
		fillRectangle: dotBounds2
		color: self handleColor.

	dotBounds2 := dotBounds2 left: (dotBounds2 left + 7).
	dotBounds2 := dotBounds2 right: (dotBounds2 right - 7).
	alphaCanvas
		fillRectangle: dotBounds2
		color: self dotColor.

	dotBounds2 := dotBounds left: (dotBounds right - windowBorderWidth).
	dotBounds2 := dotBounds2 bottom: (dotBounds2 bottom - windowBorderWidth).
	alphaCanvas
		fillRectangle: dotBounds2
		color: self handleColor.

	dotBounds2 := dotBounds2 top: (dotBounds2 top + 7).
	dotBounds2 := dotBounds2 bottom: (dotBounds2 bottom - 7).
	alphaCanvas
		fillRectangle: dotBounds2
		color: self dotColor
]

{ #category : #accessing }
BottomRightGripMorph >> gripLayoutFrame [
	^ (1 @ 1 corner: 1 @ 1) asLayoutFrame
		topLeftOffset: (0 - self defaultWidth @ (0 - self defaultHeight))
]

{ #category : #accessing }
BottomRightGripMorph >> ptName [
	^#bottomRight
]

{ #category : #accessing }
BottomRightGripMorph >> resizeCursor [

	^ Cursor resizeForEdge: #bottomRight
]
