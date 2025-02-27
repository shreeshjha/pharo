Class {
	#name : #RBMoveMethodToClassSideParametrizedTest,
	#superclass : #RBAbstractRefactoringTest,
	#category : #'Refactoring2-Transformations-Tests-Parametrized'
}

{ #category : #tests }
RBMoveMethodToClassSideParametrizedTest class >> testParameters [
	^ ParametrizedTestMatrix new
		addCase: { #rbClass -> RBMoveMethodToClassSideRefactoring };
		addCase: { #rbClass -> RBMoveMethodToClassSideTransformation };
		yourself
]

{ #category : #accessing }
RBMoveMethodToClassSideParametrizedTest >> constructor [
	^ #method:class:
]

{ #category : #'failure tests' }
RBMoveMethodToClassSideParametrizedTest >> testClassIsNotMeta [
	| method someClass className refactoring |
	className := RBRefactoryTestDataApp class.
	someClass := model classNamed: className name.
	someClass compile: 'threeElementPoint ^ self new' classified: {#example}.
	method := someClass methodFor: ('threeElement', 'Point') asSymbol.
	refactoring := self createRefactoringWithModel: model andArguments: { method . className }.
	self shouldFail: refactoring
]

{ #category : #'failure tests' }
RBMoveMethodToClassSideParametrizedTest >> testExistsMethodInClassSide [
	| method someClass className refactoring |
	className := RBRefactoryTestDataApp.
	method := className >> ('threeElement', 'Point') asSymbol.
	refactoring := self createRefactoringWithArguments: { method . className }.
	model := refactoring model.
	someClass := model classNamed: className name, ' class'.
	someClass compile: 'threeElementPoint ^ self new' classified: {#example}.
	self shouldFail: refactoring
]

{ #category : #tests }
RBMoveMethodToClassSideParametrizedTest >> testMoveMethodToClassSide [
	| method someClass className refactoring |
	className := RBRefactoryTestDataApp.
	method := className >> ('threeElement', 'Point') asSymbol.
	refactoring := self createRefactoringWithArguments: { method . className }.
	self executeRefactoring: refactoring.
	model := refactoring model.
	someClass := model classNamed: className name.
	self assert: (someClass parseTreeForSelector: ('threeElement', 'Point') asSymbol) equals: (self parseMethod: 'threeElementPoint ^ self class threeElementPoint').
	someClass := model classNamed: className name, ' class'.
	self assert: (someClass parseTreeForSelector: ('threeElement', 'Point') asSymbol) equals: (self parseMethod: 'threeElementPoint ^5 @ 5 + 6 @ 6')
]

{ #category : #tests }
RBMoveMethodToClassSideParametrizedTest >> testMoveMethodToClassSideWithInsAndMetReferences [
	| method someClass className refactoring |
	className := RBTransformationRuleTestData.
	method := className >> ('rewrite', 'Using:') asSymbol.
	refactoring := self createRefactoringWithArguments: { method . className }.
	self executeRefactoring: refactoring.
	model := refactoring model.
	someClass := model classNamed: className name.
	self assert: (someClass parseTreeForSelector: ('rewrite', 'Using:') asSymbol) equals: (self parseMethod: 'rewriteUsing: searchReplacer
	^ self class rewriteUsing: searchReplacer').
	someClass := model classNamed: className name, ' class'.
	self assert: (someClass parseTreeForSelector: ('rewrite', 'Using:') asSymbol) equals: (self parseMethod: 'rewriteUsing: searchReplacer

	| aRBTransformationRuleTestData |
	aRBTransformationRuleTestData := self new.
	aRBTransformationRuleTestData rewriteRule: searchReplacer.
	aRBTransformationRuleTestData resetResult')
]
