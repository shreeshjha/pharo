Class {
	#name : #ClyItemNameFilterTest,
	#superclass : #ClyItemFilterTest,
	#category : #'Calypso-NavigationModel-Tests'
}

{ #category : #tests }
ClyItemNameFilterTest >> testComparisonWithAnotherFilter [
	| anotherFilter |
	filter := ClyItemNameFilter substringPattern: 'filter'.

	anotherFilter := ClyItemNameFilter substringPattern: 'filter'.
	self assert: filter equals: anotherFilter.
	self assert: filter hash equals: anotherFilter hash.

	anotherFilter := ClyItemNameFilter substringPattern: 'filter2'.
	self deny: filter equals: anotherFilter
]

{ #category : #tests }
ClyItemNameFilterTest >> testFilterObjectWithName [

	filter := ClyItemNameFilter substringPattern: 'ject'. "Object"

	self assert: (filter matches: Object).
	self deny: (filter matches: Array)
]
