Extension { #name : #SharedPoolTest }

{ #category : #'*Kernel-Tests-Extended' }
SharedPoolTest >> testPoolUsers [
	| result |
	result := ChronologyConstants poolUsers.
	self assert: result asSet equals: {Date. DateAndTime. Duration. Month. Time. TimeZone. Week. LocalTimeZone . AbstractTimeZone. ExampleForTestWithSharedPool } asSet
]

{ #category : #'*Kernel-Tests-Extended' }
SharedPoolTest >> testmethodsAccessingPoolVariables [
	| result |
	result := ChronologyConstants methodsAccessingPoolVariables.
	"we find accesses to the vars of the shared pool"
	self assert: (result includes: Duration>>#asNanoSeconds).
	"but we do not include references to the pool itself"
	self deny: (result includes: ClassTest>>#testSharedPoolOfVarNamed)
]

{ #category : #'*Kernel-Tests-Extended' }
SharedPoolTest >> testusingMethods [
	| result |
	result := ChronologyConstants usingMethods.
	"we find accesses to the vars of the shared pool"
	self assert: (result includes: Duration>>#asNanoSeconds).
	"and we find references to the pool itself"
	self assert: (result includes: ClassTest>>#testSharedPoolOfVarNamed)
]
