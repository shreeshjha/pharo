"
I implement a fetcher heuristic for an AST node.
My responsibility is to build a fetcher for a given node in a given context.
I am implemented as a chain of responsibility: I treat the build request if possible, otherwise I forward the request to the next heuristic.

My main method #fetcherFor:inContext: is a template method.
My subclasses should redefine:
 - #appliesForNode:inContext: returning a boolean if the heuristic applies for context/node
 - #buildFetcherFor:inContext: returning the effective heuristic built
"
Class {
	#name : #CoASTNodeFetcherHeuristic,
	#superclass : #Object,
	#instVars : [
		'next'
	],
	#category : #'HeuristicCompletion-Model-Heuristics'
}

{ #category : #requests }
CoASTNodeFetcherHeuristic >> appliesForNode: aRBMessageNode inContext: aContext [

	^ false
]

{ #category : #requests }
CoASTNodeFetcherHeuristic >> buildFetcherFor: aRBMessageNode inContext: aContext [

	^ CoEmptyFetcher new
]

{ #category : #requests }
CoASTNodeFetcherHeuristic >> fetcherFor: aRBMessageNode inContext: aContext [

	| nextFetcher |
	nextFetcher := self next fetcherFor: aRBMessageNode inContext: aContext.
	^ (self appliesForNode: aRBMessageNode inContext: aContext)
		ifTrue: [
			(self buildFetcherFor: aRBMessageNode inContext: aContext),
				nextFetcher ]
		ifFalse: [ nextFetcher ]
]

{ #category : #initialization }
CoASTNodeFetcherHeuristic >> initialize [
	super initialize.
	next := CoNullFetcherHeuristic new
]

{ #category : #testing }
CoASTNodeFetcherHeuristic >> isStatisticsHeuristicWrapper [

	^ false
]

{ #category : #'fetcher-creation' }
CoASTNodeFetcherHeuristic >> newMessageInHierarchyFetcherForClass: aClass inASTNode: astNode [

	^ CoClassImplementedMessagesFetcher new
		astNode: astNode;
		completionClass: aClass;
		forHierarchy
]

{ #category : #accessing }
CoASTNodeFetcherHeuristic >> next [
	^ next
]

{ #category : #accessing }
CoASTNodeFetcherHeuristic >> next: nextHeuristic [
	next := nextHeuristic
]
