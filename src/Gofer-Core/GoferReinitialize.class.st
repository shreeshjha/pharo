"
I'm a private and internal class to Gofer. I'm a command used to call the class side initializers on all package code.
"
Class {
	#name : #GoferReinitialize,
	#superclass : #GoferWorking,
	#category : #'Gofer-Core-Operations'
}

{ #category : #running }
GoferReinitialize >> execute [

	self workingCopies
		do: [ :each | self execute: each ]
]

{ #category : #running }
GoferReinitialize >> execute: aWorkingCopy [

	aWorkingCopy packageSet methods do: [ :each |
		(each isClassSide and: [ each selector = #initialize ])
			ifTrue: [ each methodClass instanceSide initialize ] ]
]
