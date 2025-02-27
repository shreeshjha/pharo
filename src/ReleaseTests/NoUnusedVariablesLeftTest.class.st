"
Test to check if there are methods who have unused temporary variables in the image
"
Class {
	#name : #NoUnusedVariablesLeftTest,
	#superclass : #TestCase,
	#category : #'ReleaseTests-CleanCode'
}

{ #category : #accessing }
NoUnusedVariablesLeftTest class >> defaultTimeLimit [

	^ 2 minute
]

{ #category : #testing }
NoUnusedVariablesLeftTest >> testNoUnusedClassVariablesLeft [

	| variables classes validExceptions remaining |
	variables := Smalltalk globals allBehaviors flatCollect: [ :each | each classVariables ].
	variables := variables reject: [ :each | each isReferenced ].

	classes := variables collect: [ :each | each definingClass ] as: Set.

	validExceptions := #( OSKeySymbols FooSharedPool SDL2Constants AthensCairoDefinitions BalloonEngineConstants ShTestSharedPool RBLintRuleTestData
	                      RBDummyLintRuleTest MCMockClassF Unicode Character STONAlternativeRepresentationTestObject FLFullBasicSerializationTest
	                      SHRBStyleAttributionTest SHRBMockSharedPoolStyler ).

	remaining := classes asOrderedCollection reject: [ :each | validExceptions includes: each name ].
	self assert: remaining isEmpty description: 'the following classes have unused class variables and should be cleaned: ' , remaining asString
]

{ #category : #testing }
NoUnusedVariablesLeftTest >> testNoUnusedInstanceVariablesLeft [
	| variables classes validExceptions remaining |

	variables := Smalltalk globals allBehaviors flatCollect: [ :each | each instanceVariables ].
	variables := variables reject: [ :each | each isReferenced ].

	classes := variables collect: [ :each | each definingClass ] as: Set.

	validExceptions := { RBFooLintRuleTestData . RBLintRuleTestData .RBFooDummyLintRuleTest . RBDummyLintRuleTest. MockWithComplexSlot .ClassDescription }.

	remaining := classes asOrderedCollection removeAll: validExceptions; yourself.
	self assert: remaining isEmpty description: ('the following classes have unused instance variables and should be cleaned: ', remaining asString)
]

{ #category : #testing }
NoUnusedVariablesLeftTest >> testNoUnusedTemporaryVariablesLeft [
	"Fail if there are methods who have unused temporary variables"
	| found validExceptions |
	found := SystemNavigation default allMethodsSelect: [ :m |
		m hasTemporaries and: [m ast temporaries anySatisfy: [ :x | x binding isUsed not] ] ].

	"No other exceptions beside the ones mentioned here should be allowed"
	validExceptions := { MFClassA>>#method. MFClassB>>#method3. MFClassB>>#method2 . TemporaryVariableTest>>#testIsReferenced }.
	found removeAll: validExceptions.

	self assert: found isEmpty description: ('the following methods have unused temporary variables and should be cleaned: ', found asString)
]
