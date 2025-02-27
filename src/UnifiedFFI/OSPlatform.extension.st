Extension { #name : #OSPlatform }

{ #category : #'*UnifiedFFI' }
OSPlatform >> ffiCallingConvention [
	^ #cdecl
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> ffiFloat64Alignment [
	"By default is 4, windows and maybe others can use other"
	^ Smalltalk wordSize
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> ffiInt64Alignment [
	"By default is 4, windows and maybe others can use other"
	^ Smalltalk wordSize
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> ffiLibraryName: aLibrary [
	^ self subclassResponsibility
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> ffiLongAlignment [
	"By default is 4, windows and maybe others can use other"
	^ Smalltalk wordSize
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> ffiPointerAlignment [
	"By default is 4, windows and maybe others can use other"
	^ Smalltalk wordSize
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> processorArchitecture [
	"returns the current processor real architecture.
	Common values are:
		i386    32-bit intel
		x86_64  64-bit intel
		arm64   64-bit arm"

	^ (LibC resultOfCommand: 'uname -m') trimBoth
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> resultOfCommand: aCommand [
	"Run the given operating system command and return the piped command line result."

	^LibC resultOfCommand: aCommand
]

{ #category : #'*UnifiedFFI' }
OSPlatform >> runCommand: aCommand [
	"Run the given operating system command."

	^LibC runCommand: aCommand
]
