"
I am a dummy counterpart to the DebuggerSystem class, used to test it.
"
Class {
	#name : #OupsDummyDebuggerSystem,
	#superclass : #OupsDebuggerSystem,
	#instVars : [
		'newUIProcessSpawned',
		'customUIManager',
		'debugRequestSentToHandleDebugRequest',
		'callsToHandleDebugRequest'
	],
	#category : #'Debugger-Oups-Tests-Utils'
}

{ #category : #accessing }
OupsDummyDebuggerSystem >> callsToHandleDebugRequest [
	^callsToHandleDebugRequest ifNil: [ callsToHandleDebugRequest := 0 ]
]

{ #category : #accessing }
OupsDummyDebuggerSystem >> callsToHandleDebugRequest: aValue [
	callsToHandleDebugRequest := aValue
]

{ #category : #'default values' }
OupsDummyDebuggerSystem >> customUIManager: aUIManager [
	customUIManager := aUIManager
]

{ #category : #accessing }
OupsDummyDebuggerSystem >> debugRequestSentToHandleDebugRequest [
	^ debugRequestSentToHandleDebugRequest
]

{ #category : #'default values' }
OupsDummyDebuggerSystem >> debuggerSelectionStrategy [
	^ OupsDummySelectionStrategy new
]

{ #category : #'default values' }
OupsDummyDebuggerSystem >> defaultUIManager [
	customUIManager ifNil: [ ^ super defaultUIManager ].
	^ customUIManager
]

{ #category : #'open debugger' }
OupsDummyDebuggerSystem >> logDebugRequest: aDebugRequest withUIManager: aCommandLineUIManager [

	self openDebuggerOnRequest: aDebugRequest
]

{ #category : #accessing }
OupsDummyDebuggerSystem >> newUIProcessSpawned [
	newUIProcessSpawned ifNil: [ newUIProcessSpawned := false ].
	^ newUIProcessSpawned
]

{ #category : #'open debugger' }
OupsDummyDebuggerSystem >> openDebuggerOnRequest: aDebugRequest [
	self callsToHandleDebugRequest: self callsToHandleDebugRequest + 1.
	debugRequestSentToHandleDebugRequest := aDebugRequest.
	self performPreDebugActionsIn: aDebugRequest
]

{ #category : #helpers }
OupsDummyDebuggerSystem >> spawnNewUIProcess [
	"For testing purposes. Does not actually spawn a new UI process. Just record that this method was called"
	newUIProcessSpawned := true
]

{ #category : #helpers }
OupsDummyDebuggerSystem >> suspendDebuggedProcess: aDebugRequest [
	"Do not actually suspend the debugged process, in order to prevent the UI process from being suspended (image freeze) if a test goes wrong"
	^ 1
]

{ #category : #'open debugger' }
OupsDummyDebuggerSystem >> warningRequest: aDebugRequest withUIManager: aCommandLineUIManager [

	self openDebuggerOnRequest: aDebugRequest
]
