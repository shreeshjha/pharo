Class {
	#name : #ClyHierarchicallySortedClassesTest,
	#superclass : #ClyBrowserQueryResultTest,
	#category : #'Calypso-SystemQueries-Tests-Results'
}

{ #category : #running }
ClyHierarchicallySortedClassesTest >> createQueryResult [
	^ClyHierarchicallySortedClassesResult new
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testComparisonWithResultWithAnotherHierarchyType [
	| queryResult2 |
	queryResult2 := self createQueryResult.
	queryResult2 hierarchy: #anotherHierarchy.

	self deny: queryResult equals: queryResult2
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testComparisonWithResultWithAnotherSortFunction [
	| queryResult2 |
	queryResult2 := queryResult sortedBy: #anotherSortFunction.

	self deny: queryResult equals: queryResult2.
	self deny: queryResult identicalTo: queryResult2
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testComparisonWithResultWithSameHierarchyAbdSortFunction [
	| queryResult2 |
	queryResult2 := queryResult sortedBy: queryResult hierarchy sortFunction.

	self assert: queryResult equals: queryResult2.
	self assert: queryResult hash equals: queryResult2 hash
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testComparisonWithResultWithSimilarInverseHierarchy [
	| queryResult2 |
	queryResult2 := self createQueryResult.
	queryResult2 := queryResult2 withInverseHierarchy.

	self deny: queryResult equals: queryResult2
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testFillingWithClassAndItGrandSuperclass [

	queryResult fillWith: { ClyClass1FromP1Mock. ClySubclassLOfSubclassMFromP3Mock }.

	self assertItems: {ClyClass1FromP1Mock. 0. ClySubclassLOfSubclassMFromP3Mock. 1}
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testFillingWithClassesFromOneHierarchy [

	queryResult fillWith: { ClySubclassN1OfClass1FromP1Mock. ClySubclassLOfSubclassMFromP3Mock. ClyClass1FromP1Mock. ClySubclassN2OfClass1FromP1Mock }.

	self assertItems: {
		ClyClass1FromP1Mock. 0. ClySubclassLOfSubclassMFromP3Mock. 1.
		ClySubclassN1OfClass1FromP1Mock. 1. ClySubclassN2OfClass1FromP1Mock. 1 }
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testFillingWithObjectAndTwoProtoObjects [

	queryResult fillWith: { Object. ProtoObject. ProtoObject }.

	self assertItems: {ProtoObject. 0. Object. 1}
]

{ #category : #tests }
ClyHierarchicallySortedClassesTest >> testFillingWithTwoSameClasses [

	queryResult fillWith: { ClyClass1FromP1Mock. ClyClass1FromP1Mock }.

	self assertItems: { ClyClass1FromP1Mock. 0 }
]
