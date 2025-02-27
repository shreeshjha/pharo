"
i am the root of keyboard events hierarchy.

The scan code represents an unique number identifying a key and comes directly from OS.
Some keys can be directly translated to corresponding character(s) by OS and thus such events will carry character ~= nil.  Character translation is not reliable with this event because many characters are introduced by using multiples key strokes. For a reliable way for getting text input, it is better to listen for the OSTextInputEvent.

character - An character representation of the key.
modifiers - Extra flags telling if special keys such as ctrl, alt, cmd, etc are being held.
position - The position of the mouse cursor when the key was pressed.
scanCode - Raw keyboard scan scode.
repeat - This value is non-zero if this event was originated by a repeated key stroke.
symbol - A virtual platform independent identifier for a keyboard key. Valid values are defined in the OSKeySymbols pool dictionary.
"
Class {
	#name : #OSKeyboardEvent,
	#superclass : #OSEvent,
	#instVars : [
		'scanCode',
		'symbol',
		'character',
		'modifiers',
		'position',
		'repeat',
		'handled'
	],
	#category : #'OSWindow-Core-Events'
}

{ #category : #keymapping }
OSKeyboardEvent >> asKeyCombination [
	| modifier control command shift alt char |

	control := self modifiers ctrl.
	command := self modifiers cmd.
	shift := self modifiers shift.
	alt := self modifiers alt.
	char := self modifiedCharacter.

	(shift | command | control | alt)
		ifFalse: [^ KMSingleKeyCombination from: char ].

	modifier := KMNoShortcut new.
	control ifTrue: [ modifier := modifier + KMModifier ctrl ].
	command ifTrue: [ modifier := modifier + KMModifier command ].
	shift ifTrue: [ modifier := modifier + KMModifier shift ].
	alt ifTrue: [ modifier := modifier + KMModifier alt ].

	^ modifier + char
]

{ #category : #accessing }
OSKeyboardEvent >> character [

	^ character
]

{ #category : #accessing }
OSKeyboardEvent >> character: anObject [

	character := anObject
]

{ #category : #accessing }
OSKeyboardEvent >> characterCode [
	"answer the unicode value"

	^ character ifNil: [0] ifNotNil: [ character charCode ]
]

{ #category : #initialization }
OSKeyboardEvent >> initialize [
	super initialize.
	modifiers := OSStateModifiers new.
	handled := false
]

{ #category : #keymapping }
OSKeyboardEvent >> modifiedCharacter [

	self character ifNotNil: [ :c | ^ c ].
	self symbol <= 16rFF ifTrue: [ ^ Character value: self symbol ].
	^ Character value: 0
]

{ #category : #accessing }
OSKeyboardEvent >> modifiers [

	^ modifiers
]

{ #category : #accessing }
OSKeyboardEvent >> position [

	^ position
]

{ #category : #accessing }
OSKeyboardEvent >> position: anObject [

	position := anObject
]

{ #category : #printing }
OSKeyboardEvent >> printOn: stream [
	super printOn: stream.
	stream space; nextPutAll: 'scanCode: '; print: scanCode.
	stream space; nextPutAll: 'symbol '; print: symbol.
	stream space; nextPutAll: 'character '; print: character.
	stream space; nextPutAll: 'modifiers: '; print: modifiers
]

{ #category : #accessing }
OSKeyboardEvent >> repeat [
	^ repeat
]

{ #category : #accessing }
OSKeyboardEvent >> repeat: anObject [
	repeat := anObject
]

{ #category : #accessing }
OSKeyboardEvent >> scanCode [

	^ scanCode
]

{ #category : #accessing }
OSKeyboardEvent >> scanCode: anObject [

	scanCode := anObject
]

{ #category : #accessing }
OSKeyboardEvent >> symbol [

	^ symbol
]

{ #category : #accessing }
OSKeyboardEvent >> symbol: anObject [

	symbol := anObject
]

{ #category : #keymapping }
OSKeyboardEvent >> wasHandled [
	^ handled
]

{ #category : #keymapping }
OSKeyboardEvent >> wasHandled: aBoolean [
	handled := aBoolean
]
