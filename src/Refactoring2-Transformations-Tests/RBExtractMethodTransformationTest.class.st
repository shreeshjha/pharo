Class {
	#name : #RBExtractMethodTransformationTest,
	#superclass : #RBTransformationTest,
	#category : #'Refactoring2-Transformations-Tests-Test'
}

{ #category : #private }
RBExtractMethodTransformationTest >> sourceCodeAt: anInterval forMethod: aSelector in: aClass [

	^ (aClass sourceCodeAt: aSelector)
		copyFrom: anInterval first to: anInterval last
]

{ #category : #'tests - failures' }
RBExtractMethodTransformationTest >> testBadInterval [

	self shouldFail: (RBExtractMethodTransformation
							extract: 'whatever'
							from: #testMethod to: #bla
							in: #RBRefactoryTestDataApp)
							asRefactoring.

	self shouldFail: (RBExtractMethodTransformation
							extract: (self sourceCodeAt: (80 to: 147)
								forMethod: #subclassOf:overrides: in: RBBasicLintRuleTestData class)
							from: #subclassOf:overrides: to: #bla
							in: #'RBBasicLintRuleTestData class')
							asRefactoring
]

{ #category : #'tests - failures' }
RBExtractMethodTransformationTest >> testExtractFailure [

	self shouldFail: (RBExtractMethodTransformation
			extract: (self sourceCodeAt: (80 to: 269)
						forMethod: #subclassOf:overrides: in: RBBasicLintRuleTestData class)
			from: #subclassOf:overrides:
			to: #foo in: #'RBBasicLintRuleTestData class')
			asRefactoring.

	self shouldFail: (RBExtractMethodTransformation
			extract: (self sourceCodeAt: (53 to: 56)
						forMethod: #subclassOf:overrides: in: RBBasicLintRuleTestData class)
			from: #subclassOf:overrides:
			to: #foo in: #'RBBasicLintRuleTestData class')
			asRefactoring.

	self shouldFail: (RBExtractMethodTransformation
			extract: (self sourceCodeAt: (77 to: 222)
						forMethod: #subclassResponsibilityNotDefined in: RBBasicLintRuleTestData class)
			from: #subclassResponsibilityNotDefined
			to: #foo in: #'RBBasicLintRuleTestData class')
			asRefactoring
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testExtractUsingExistingMethodRefactoring [

	| transformation class |
	transformation := (RBExtractMethodTransformation
		extract: 'rewriteRule tree printString'
		from: #checkMethod:
		to: #bar
		in: #RBTransformationRuleTestData).
	transformation setOption: #useExistingMethod toUse: [ :re :sel | true ].
	transformation asRefactoring transform.
	self assert: transformation model changes changes size equals: 1.

	class := transformation model classNamed: #RBTransformationRuleTestData.
	self assert: (class parseTreeForSelector: #checkMethod:)
		  equals: (self parseMethod: 'checkMethod: aSmalllintContext
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: [
		(RecursiveSelfRule
			 executeTree: rewriteRule tree
			 initialAnswer: false) ifFalse: [
			builder
				compile: self rewriteRuleAsString
				in: class
				classified: aSmalllintContext protocols ] ]').
	self deny: (class directlyDefinesMethod: #bar)
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testExtractWithoutUseExistingMethodRefactoring [

	| transformation class |
	transformation := (RBExtractMethodTransformation
		extract: 'rewriteRule tree printString'
		from: #checkMethod:
		to: #bar
		in: #RBTransformationRuleTestData).
	transformation setOption: #useExistingMethod toUse: [ :re :sel | false ].
	transformation asRefactoring transform.
	self assert: transformation model changes changes size equals: 2.

	class := transformation model classNamed: #RBTransformationRuleTestData.
	self assert: (class parseTreeForSelector: #checkMethod:)
		  equals: (self parseMethod: 'checkMethod: aSmalllintContext
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: [
		(RecursiveSelfRule
			 executeTree: rewriteRule tree
			 initialAnswer: false) ifFalse: [
			builder
				compile: self bar
				in: class
				classified: aSmalllintContext protocols ] ]').
	self assert: (class parseTreeForSelector: #bar)
		equals: (self parseMethod: 'bar
		rewriteRule tree printString').
	self assert: (class directlyDefinesMethod: #bar)
]

{ #category : #'tests - failures' }
RBExtractMethodTransformationTest >> testMethodDoesNotExist [

	self shouldFail: (RBExtractMethodTransformation
			extract: 'bla'
			from: #checkClass1:
			to: #bla
			in: #RBBasicLintRuleTestData)
			asRefactoring
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testNeedsReturn [

	| refactoring class |
	refactoring := (RBExtractMethodTransformation
						extract: 'rules isEmpty ifTrue: [^self].
						rules size == 1 ifTrue: [^rules first viewResults]'
						from: #openEditor
						to: #foo: in: #RBDummyLintRuleTest)
						asRefactoring transform.

	self assert: refactoring model changes changes size equals: 2.

	class := refactoring model classNamed: #RBDummyLintRuleTest.
	self assert: (class parseTreeForSelector: #openEditor)
		  equals: (self parseMethod: 'openEditor
				| rules |
				rules := self failedRules.
				^self foo: rules').
	self assert: (class parseTreeForSelector: #foo:)
		  equals: (self parseMethod: 'foo: rules
				rules isEmpty ifTrue: [^self].
				rules size == 1 ifTrue: [^rules first viewResults]')
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testRefactoring [

	| transformation class |
	transformation := (RBExtractMethodTransformation
		extract: '(RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
			ifFalse: [builder
						compile: rewriteRule tree printString
						in: class
						classified: aSmalllintContext protocols]'
		from: #checkMethod:
		to: #foo:
		in: #RBTransformationRuleTestData)
		asRefactoring transform.

	self assert: transformation model changes changes size equals: 2.

	class := transformation model classNamed: #RBTransformationRuleTestData.
	self assert: (class parseTreeForSelector: #checkMethod:)
		  equals: (self parseMethod: 'checkMethod: aSmalllintContext
			class := aSmalllintContext selectedClass.
			(rewriteRule executeTree: aSmalllintContext parseTree)
				ifTrue: [self foo: aSmalllintContext]').
	self assert: (class parseTreeForSelector: #foo:)
		  equals: (self parseMethod: 'foo: aSmalllintContext
			(RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
				ifFalse: [ builder
							compile: rewriteRule tree printString
							in: class
							classified: aSmalllintContext protocols ]')
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testTransform [

	| transformation class |
	transformation := (RBAddMethodTransformation
					sourceCode: 'foo
									| temp bar |
									bar := 5.
									temp := bar * bar.
									Transcript show: temp printString; cr.
									^temp * temp'
					in: self changeMock name
					withProtocols: {#accessing})
					transform.

	transformation := (RBExtractMethodTransformation
				model: transformation model
				extract: 'bar := 5.
							temp := bar * bar.
							Transcript show: temp printString; cr'
				from: #foo
				to: #foobar
				in: self changeMock name)
				transform.

	self assert: transformation model changes changes size equals: 4.

	class := transformation model classNamed: self changeMock name.
	self assert: (class parseTreeForSelector: #foo)
		  equals: (self parseMethod: 'foo
													| temp |
													temp := self foobar.
													^temp * temp').
	self assert: (class parseTreeForSelector: #foobar)
		  equals: (self parseMethod: 'foobar
													| temp bar |
													bar := 5.
													temp := bar * bar.
													Transcript show: temp printString; cr.
													^temp.')
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testWithArgument [

	| refactoring class |
	refactoring := (RBExtractMethodTransformation
		extract: (self sourceCodeAt: (143 to: 340)
					 forMethod: #checkMethod: in: RBTransformationRuleTestData)
		from: #checkMethod:
		to: #foo:
		in: #RBTransformationRuleTestData)
		asRefactoring transform.

	self assert: refactoring model changes changes size equals: 2.

	class := refactoring model classNamed: #RBTransformationRuleTestData.
	self assert: (class parseTreeForSelector: #checkMethod:)
		  equals: (self parseMethod: 'checkMethod: aSmalllintContext
					class := aSmalllintContext selectedClass.
					(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue:
						[self foo: aSmalllintContext]').
	self assert: (class parseTreeForSelector: #foo:)
		  equals: (self parseMethod: 'foo: aSmalllintContext
					(RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
						ifFalse:
							[builder compile: rewriteRule tree printString
										in: class
										classified: aSmalllintContext protocols]')
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testWithTemporariesSelected [

	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class compile: 'foo [| temp | temp := 5. temp * temp] value'
		classified: #(#accessing).

	refactoring := (RBExtractMethodTransformation
		model: model
		extract: '| temp | temp := 5. temp * temp'
		from: #foo
		to: #foobar
		in: class)
		asRefactoring transform.

	self assert: refactoring model changes changes size equals: 4.
	self assert: (class parseTreeForSelector: #foo)
		  equals: (self parseMethod: 'foo [self foobar] value').
	self assert: (class parseTreeForSelector: #foobar)
		  equals: (self parseMethod: 'foobar |temp | temp := 5. ^temp * temp')
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testWithTemporaryAssigned [

	| class method refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	method := 'foo
			| temp bar |
			bar := 5.
			temp := bar * bar.
			Transcript show: temp printString; cr.
			^temp * temp'.
	class compile: method classified: #(#accessing).

	refactoring := (RBExtractMethodTransformation
			model: model
			extract: (method copyFrom: 24 to: 98)
			from: #foo
			to: #foobar
			in: class)
			asRefactoring transform.

	self assert: refactoring model changes changes size equals: 4.
	self assert: (class parseTreeForSelector: #foo)
		  equals: (self parseMethod: 'foo | temp | temp := self foobar. ^temp * temp').
	self assert: (class parseTreeForSelector: #foobar)
		  equals: (self parseMethod: 'foobar | temp bar | bar := 5. temp := bar * bar. Transcript show: temp printString; cr. ^temp.')
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testWithTemporaryVariable [

	| refactoring class |
	refactoring := (RBExtractMethodTransformation
		extract: (self
			sourceCodeAt: (22 to: 280)
			forMethod: #superSends in: RBTransformationRuleTestData)
		from: #superSends
		to: #foo1 in: #RBTransformationRuleTestData)
		asRefactoring transform.

	self assert: refactoring model changes changes size equals: 2.

	class := refactoring model classNamed: #RBTransformationRuleTestData.
	self assert: (class parseTreeForSelector: #superSends)
		  equals: (self parseMethod: 'superSends
				| rule |
				rule := self foo1.
				self rewriteUsing: rule').
	self assert: (class parseTreeForSelector: #foo1)
		  equals: (self parseMethod: 'foo1 | rule |
				rule := RBParseTreeRewriter new.
				rule addSearch: ''super `@message: ``@args''
					-> ([:aNode |
					(class withAllSubclasses
						detect: [:each | each includesSelector: aNode selector]
						ifNone: [nil]) isNil]
							-> ''self `@message: ``@args'').
				^rule')
]

{ #category : #tests }
RBExtractMethodTransformationTest >> testWithTemporaryVariable2 [

	| refactoring class |
	refactoring := (RBExtractMethodTransformation
		extract: (self sourceCodeAt: (78 to: 197)
					forMethod: #displayName in: RBDummyLintRuleTest)
		from: #displayName
		to: #foo:
		in: #RBDummyLintRuleTest)
		asRefactoring transform.

	self assert: refactoring model changes changes size equals: 2.

	class := refactoring model classNamed: #RBDummyLintRuleTest.
	self assert: (class parseTreeForSelector: #displayName)
		  equals: (self parseMethod: 'displayName
					| nameStream |
					nameStream := WriteStream on: (String new: 64).
					self foo: nameStream.
					^nameStream contents').
	self assert: (class parseTreeForSelector: #foo:)
		  equals: (self parseMethod: 'foo: nameStream
					nameStream nextPutAll: self name;
								nextPutAll: '' (''.
					self problemCount printOn: nameStream.
					nameStream nextPut: $).')
]
