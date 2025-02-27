"
Move assignment out of unwind blocks.

For example

[[[
[ statements. 
var := object ] ifCurtailed: block
]]]


[[[ 
var := [ statements. 
	    object] ifCurtailed: block
]]]
"
Class {
	#name : #ReUnwindBlocksRule,
	#superclass : #ReNodeRewriteRule,
	#category : #'GeneralRules-Migrated'
}

{ #category : #accessing }
ReUnwindBlocksRule class >> uniqueIdentifierName [
	"This number should be unique and should change only when the rule completely change semantics"

	^'UnwindBlocksRule'
]

{ #category : #accessing }
ReUnwindBlocksRule >> group [
	^ 'Optimization'
]

{ #category : #initialization }
ReUnwindBlocksRule >> initialize [
	super initialize.
	self
		replace: '[| `@temps | ``@.Statements. `var := ``@object] ensure: ``@block'
			with: '`var := [| `@temps | ``@.Statements. ``@object] ensure: ``@block';
		replace: '[| `@temps | ``@.Statements. ^``@object] ensure: ``@block'
			with: '^[| `@temps | ``@.Statements. ``@object] ensure: ``@block';
		replace:'[| `@temps | ``@.Statements. `var := ``@object] ifCurtailed: ``@block'
			with: '`var := [| `@temps | ``@.Statements. ``@object] ifCurtailed: ``@block';
		replace:'[| `@temps | ``@.Statements. ^``@object] ifCurtailed: ``@block'
			with: '^[| `@temps | ``@.Statements. ``@object] ifCurtailed: ``@block'
]

{ #category : #accessing }
ReUnwindBlocksRule >> name [
	^ 'Move assignment out of unwind blocks'
]
