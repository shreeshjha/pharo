Extension { #name : #String }

{ #category : #'*Metacello-Core' }
String >> addToMetacelloPackages: aMetacelloPackagesSpec [

	| spec |
	spec := 
		(aMetacelloPackagesSpec project packageSpec)
			file: self;
			yourself.
	aMetacelloPackagesSpec addMember: 
		(aMetacelloPackagesSpec addMember 
			name: spec name;
			spec: spec;
			yourself)
]

{ #category : #'*Metacello-Core' }
String >> asMetacelloSemanticVersionNumber [
    ^ MetacelloSemanticVersionNumber fromString: self
]

{ #category : #'*Metacello-Core' }
String >> asMetacelloVersionNumber [

	^MetacelloVersionNumber fromString: self
]

{ #category : #'*Metacello-Core' }
String >> execute: projectSpecBlock against: aScriptExecutor [
    aScriptExecutor executeString: self do: projectSpecBlock
]

{ #category : #'*Metacello-Core' }
String >> mergeIntoMetacelloPackages: aMetacelloPackagesSpec [

	| spec |
	spec := 
		(aMetacelloPackagesSpec project packageSpec)
			file: self;
			yourself.
	aMetacelloPackagesSpec addMember: 
		(aMetacelloPackagesSpec mergeMember 
			name: spec name;
			spec: spec;
			yourself)
]

{ #category : #'*Metacello-Core-version comparison' }
String >> metacelloIntegerLessThanSelf: anInteger [
	"integer version components are always '>' string component"

	^false
]

{ #category : #'*Metacello-Core-version comparison' }
String >> metacelloSemanticIntegerLessThanSelf: anInteger [
    "integer version components are always '>' string component"

    ^ true
]

{ #category : #'*Metacello-Core-version comparison' }
String >> metacelloSemanticStringLessThanSelf: aString [
    ^ aString < self
]

{ #category : #'*Metacello-Core-version comparison' }
String >> metacelloSemanticVersionComponentLessThan: aMetacelloVersonComponent [
    ^ aMetacelloVersonComponent metacelloSemanticStringLessThanSelf: self
]

{ #category : #'*Metacello-Core-version comparison' }
String >> metacelloStringLessThanSelf: aString [

	^aString < self
]

{ #category : #'*Metacello-Core-version comparison' }
String >> metacelloVersionComponentLessThan: aMetacelloVersonComponent [

	^aMetacelloVersonComponent metacelloStringLessThanSelf: self
]

{ #category : #'*Metacello-Core' }
String >> removeFromMetacelloPackages: aMetacelloPackagesSpec [

	aMetacelloPackagesSpec addMember: 
		(aMetacelloPackagesSpec removeMember 
			name: self;
			yourself)
]

{ #category : #'*Metacello-Core' }
String >> setAuthorInMetacelloConfig: aMetacelloConfig [

	aMetacelloConfig setAuthorWithString: self
]

{ #category : #'*Metacello-Core' }
String >> setAuthorInMetacelloVersion: aMetacelloVersionSpec [

	aMetacelloVersionSpec setAuthor: 
		(aMetacelloVersionSpec project valueHolderSpec
			value: self;
			yourself)
]

{ #category : #'*Metacello-Core' }
String >> setBlessingInMetacelloConfig: aMetacelloConfig [

	aMetacelloConfig setBlessingWithString: self
]

{ #category : #'*Metacello-Core' }
String >> setBlessingInMetacelloVersion: aMetacelloVersionSpec [

	aMetacelloVersionSpec setBlessing: 
		(aMetacelloVersionSpec project valueHolderSpec
			value: self;
			yourself)
]

{ #category : #'*Metacello-Core' }
String >> setDescriptionInMetacelloConfig: aMetacelloConfig [

	aMetacelloConfig setDescriptionWithString: self
]

{ #category : #'*Metacello-Core' }
String >> setDescriptionInMetacelloVersion: aMetacelloVersionSpec [

	aMetacelloVersionSpec setDescription: 
		(aMetacelloVersionSpec project valueHolderSpec
			value: self;
			yourself)
]

{ #category : #'*Metacello-Core' }
String >> setImportInVersionSpec: aMetacelloVersionSpec [
  aMetacelloVersionSpec setImport: {self}
]

{ #category : #'*Metacello-Core' }
String >> setIncludesInMetacelloPackage: aMetacelloPackageSpec [

	aMetacelloPackageSpec setIncludes: { self }.
]

{ #category : #'*Metacello-Core' }
String >> setLoadsInMetacelloProject: aMetacelloPackageSpec [

	aMetacelloPackageSpec setLoads: { self }.
]

{ #category : #'*Metacello-Core' }
String >> setPackage: aString withInMetacelloConfig: aMetacelloConfig [

	aMetacelloConfig setPackage: aString withString: self
]

{ #category : #'*Metacello-Core' }
String >> setPostLoadDoItInMetacelloSpec: aMetacelloSpec [
    self asSymbol setPostLoadDoItInMetacelloSpec: aMetacelloSpec
]

{ #category : #'*Metacello-Core' }
String >> setPreLoadDoItInMetacelloSpec: aMetacelloSpec [
    self asSymbol setPreLoadDoItInMetacelloSpec: aMetacelloSpec
]

{ #category : #'*Metacello-Core' }
String >> setProject: aString withInMetacelloConfig: aMetacelloConfig [

	aMetacelloConfig setProject: aString withString: self
]

{ #category : #'*Metacello-Core' }
String >> setRequiresInMetacelloPackage: aMetacelloPackageSpec [

	aMetacelloPackageSpec setRequires: { self }.
]

{ #category : #'*Metacello-Core' }
String >> setTimestampInMetacelloConfig: aMetacelloConfig [

	aMetacelloConfig setTimestampWithString: self
]

{ #category : #'*Metacello-Core' }
String >> setTimestampInMetacelloVersion: aMetacelloVersionSpec [

	aMetacelloVersionSpec setTimestamp: 
		(aMetacelloVersionSpec project valueHolderSpec
			value: self;
			yourself)
]
