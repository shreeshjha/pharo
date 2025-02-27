"
handle holds a (typically 32-bit) pointer to an externally managed object.
"
Class {
	#name : #FT2Handle,
	#superclass : #FFIExternalObject,
	#pools : [
		'FT2Constants'
	],
	#category : #'FreeType-Base'
}

{ #category : #compiling }
FT2Handle class >> compileAllFieldsInOrder [
	"Force the correct order of generation of FFI Bindings"
	"This used to be done in #startUp:, we keep it in case FTBindings are changed and have to be regenerated"
 	FTBitmap compileFields.
 	FTBitmapSize compileFields.
 	FTGeneric compileFields.
 	FTBBox compileFields.

 	FTCharMapRec compileFields.
 	FTGlyphSlotRec compileFields.
 	FTFaceRec compileFields
]

{ #category : #initialization }
FT2Handle >> beNull [

	^ self handle beNull
]

{ #category : #'error handling' }
FT2Handle >> errorCode [

	^ FT2Library current errorCode
]

{ #category : #'error handling' }
FT2Handle >> errorString [

	^ FT2Library current errorString
]

{ #category : #'library path' }
FT2Handle >> ffiLibraryName [

	^ FT2FFILibrary
]

{ #category : #initialization }
FT2Handle >> initialize [

	self shouldNotImplement
]

{ #category : #testing }
FT2Handle >> isValid [

	^ self isNull not
]

{ #category : #printing }
FT2Handle >> printOn: aStream [

	| handleHex |
	super printOn: aStream.
	handle ifNil: [ ^ aStream nextPutAll: '<nil>' ].
	handleHex := (handle
		              unsignedLongAt: 1
		              bigEndian: EndianDetector isBigEndian) printStringHex.
	aStream
		nextPutAll: '<0x';
		nextPutAll: handleHex;
		nextPut: $>
]
