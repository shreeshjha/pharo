Class {
	#name : #RBMethodProtocolTransformationTest,
	#superclass : #RBTransformationTest,
	#category : #'Refactoring2-Transformations-Tests-Test'
}

{ #category : #tests }
RBMethodProtocolTransformationTest >> testClassDoesNotExist [

	self shouldFail: (RBMethodProtocolTransformation
							protocol: 'empty protocol 2'
							inMethod: #someMethod
							inClass: #RBDummyEmptyClass123)
							asRefactoring
]

{ #category : #tests }
RBMethodProtocolTransformationTest >> testMethodDoesNotExist [

	self shouldFail: (RBMethodProtocolTransformation
							protocol: 'empty protocol 2'
							inMethod: #method
							inClass: #RBDummyEmptyClass)
							asRefactoring
]

{ #category : #tests }
RBMethodProtocolTransformationTest >> testRefactoring [
	| refactoring |
	self assert: (RBDummyEmptyClass organization protocolOrganizer protocolNamed: 'empty protocol 2') isEmpty.

	refactoring := (RBMethodProtocolTransformation protocol: 'empty protocol 2' inMethod: #someMethod inClass: #RBDummyEmptyClass) asRefactoring transform.
	RBRefactoryChangeManager instance performChange: refactoring changes.

	self deny: (RBDummyEmptyClass organization protocolOrganizer protocolNamed: 'empty protocol 2') isEmpty.

	refactoring := (RBMethodProtocolTransformation protocol: 'empty protocol 1' inMethod: #someMethod inClass: #RBDummyEmptyClass) asRefactoring transform.
	RBRefactoryChangeManager instance performChange: refactoring changes.

	self assert: (RBDummyEmptyClass organization protocolOrganizer protocolNamed: 'empty protocol 2') isEmpty
]

{ #category : #tests }
RBMethodProtocolTransformationTest >> testTransform [

	| transformation |
	self assert: ( RBDummyEmptyClass
		organization protocolOrganizer
		protocolNamed: 'empty protocol 2' ) isEmpty.

	transformation := (RBMethodProtocolTransformation new
		protocol: 'empty protocol 2'
		inMethod: #someMethod
		inClass: #RBDummyEmptyClass)
		transform.
	RBRefactoryChangeManager instance performChange: transformation changes.

	self assert: ( RBDummyEmptyClass
		organization protocolOrganizer
		protocolNamed: 'empty protocol 2' ) isEmpty not.

	transformation := (RBMethodProtocolTransformation new
		protocol: 'empty protocol 1'
		inMethod: #someMethod
		inClass: #RBDummyEmptyClass)
		transform.
	RBRefactoryChangeManager instance performChange: transformation changes.
	self assert: ( RBDummyEmptyClass
		organization protocolOrganizer
		protocolNamed: 'empty protocol 2' ) isEmpty
]
