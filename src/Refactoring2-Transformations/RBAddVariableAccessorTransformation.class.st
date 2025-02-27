"
Adds accessors (getter and setter) for a variable in a class, if they do not exist.

Usage:
| transformation |
transformation := (RBAddVariableAccessorTransformation
	variable: 'variableName'
	class: #RBVariableTransformation
	classVariable: false)
	transform.
(ChangesBrowser changes: transformation model changes changes) open

Preconditions:
- the variable with which the accessors will be created shall exist. The parameter isClassVariable indicates whether to look in the instance or class variables.
"
Class {
	#name : #RBAddVariableAccessorTransformation,
	#superclass : #RBVariableTransformation,
	#instVars : [
		'getterMethod',
		'setterMethod'
	],
	#category : #'Refactoring2-Transformations-Model'
}

{ #category : #private }
RBAddVariableAccessorTransformation >> createGetterAccessor [

	(self definingClass getterMethodFor: variableName) ifNil: [ self defineGetterMethod ]
]

{ #category : #private }
RBAddVariableAccessorTransformation >> createSetterAccessor [

	(self definingClass setterMethodFor: variableName) ifNil: [ self defineSetterMethod ]
]

{ #category : #private }
RBAddVariableAccessorTransformation >> defineGetterMethod [

	getterMethod := self safeMethodNameFor: self definingClass basedOn: variableName asString.
	self definingClass
		compile: ('<1s><r><r><t>^ <2s>' expandMacrosWith: getterMethod with: variableName)
		classified: #(#accessing).
	^ getterMethod
]

{ #category : #private }
RBAddVariableAccessorTransformation >> defineSetterMethod [

	|  sourceCode |
	sourceCode := '<1s> anObject<r><r><t><2s> := anObject'.
	setterMethod := self safeMethodNameFor: self definingClass basedOn: variableName asString , ':'.
	self definingClass
		compile: (sourceCode expandMacrosWith: setterMethod with: variableName)
		classified: #accessing.
	^setterMethod
]

{ #category : #private }
RBAddVariableAccessorTransformation >> getterMethod [
	^ getterMethod
]

{ #category : #preconditions }
RBAddVariableAccessorTransformation >> preconditions [

	class := self model classObjectFor: className.

	^ isClassVariable
		ifTrue: [RBCondition definesClassVariable: variableName asSymbol in: class]
		ifFalse: [RBCondition definesInstanceVariable: variableName in: class]
]

{ #category : #executing }
RBAddVariableAccessorTransformation >> privateTransform [

	self
		createGetterAccessor;
		createSetterAccessor
]

{ #category : #private }
RBAddVariableAccessorTransformation >> safeMethodNameFor: aClass basedOn: aString [
	"Creates an unused method name containing aString"

	| baseString newString hasParam i |
	baseString := aString copy.
	baseString at: 1 put: baseString first asLowercase.
	newString := baseString.
	hasParam := newString last = $:.
	hasParam
		ifTrue: [baseString := newString copyFrom: 1 to: newString size - 1].
	i := 0.
	[aClass hierarchyDefinesMethod: newString asSymbol] whileTrue:
			[i := i + 1.
			newString := baseString , i printString
						, (hasParam ifTrue: [':'] ifFalse: [''])].
	^newString asSymbol
]

{ #category : #private }
RBAddVariableAccessorTransformation >> setterMethod [
	^ setterMethod
]
