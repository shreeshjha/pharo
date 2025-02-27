"
I am a fetcher looking for globals in an environment.
"
Class {
	#name : #CoGlobalVariableFetcher,
	#superclass : #CoGlobalFetcher,
	#category : #'HeuristicCompletion-Model-Fetchers'
}

{ #category : #enumerating }
CoGlobalVariableFetcher >> entriesDo: aBlock [

	self systemNavigation
		allClassNamesStartingWith: filter completionString
		do: [ :e | aBlock value: (NECGlobalEntry contents: e node: astNode) ]
		caseSensitive: (NECPreferences caseSensitive)
]
