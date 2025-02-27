"
TimeProfiler is a graphical front end of MessageTally. It gives nice facilities to navigate and browse a profile.

Use examples:
TimeProfiler new open
TimeProfiler new openOnBlock: [SimpleGridExample new open]
TimeProfiler new openOnBlock: [ClassTreeExample new openOn: Object]
 MessageTally spyAllOn: [ClassTreeExample new openOn: Object]
"
Class {
	#name : #TimeProfiler,
	#superclass : #MorphTreeModel,
	#instVars : [
		'win',
		'rootMessageTally',
		'threshold',
		'minPercentageToExpand',
		'treeMorph',
		'block',
		'blockCodePane',
		'withBlockCodePane',
		'blockSource',
		'reportOtherProcesses',
		'showLeavesOnly',
		'codeTabPane',
		'resultPane',
		'result',
		'withToolBar'
	],
	#category : #'Tool-Profilers-Time'
}

{ #category : #examples }
TimeProfiler class >> example [

	[1000 timesRepeat: [3.14159 printString. Processor yield]] fork.
	[1000 timesRepeat: [20 factorial. Processor yield]] fork.
	[1000 timesRepeat: [20 factorial. Processor yield]] fork.
	self spyAllOn: [ (Delay forMilliseconds: 100) wait]
]

{ #category : #examples }
TimeProfiler class >> exampleOnBlock [

	TimeProfiler onBlock: [ 20 timesRepeat: [self trace: 100 factorial printString]]
]

{ #category : #opening }
TimeProfiler class >> fullReportMenuOn: aBuilder [
	"Specify the menu with a specific pragma. Try it with:
	(PragmaMenuBuilder
		pragmaKeyword: 'TimeProfilerFullReportMenu'
		model: nil) menu popUpInWorld"

	<contextMenu>
	<TimeProfilerFullReportMenu>
	(aBuilder item: #'Find...' translated)
		keyText: 'f';
		selector: #find;
		iconName: #smallFind.
	(aBuilder item: #'Find again' translated)
		keyText: 'g';
		selector: #findAgain;
		iconNamed: #smallFind.
	(aBuilder item: #'Set search string' translated)
		keyText: 'h';
		selector: #setSearchString.
	(aBuilder item: #Copy translated)
		keyText: 'c';
		selector: #copySelection;
		iconName: #smallCopy
]

{ #category : #'world menu' }
TimeProfiler class >> menuProfilingOn: aBuilder [
	<worldMenu>

	(aBuilder item: #'Start profiling all Processes')
		parent: #Profiling;
		help: 'Profile all Pharo processes.';
		order: 10;
		action: [ self currentWorld worldState startMessageTally ].
	(aBuilder item: #'Start profiling UI ')
		parent: #Profiling;
		help: 'Profile the UI process of Pharo.';
		order: 20;
		action: [ self currentWorld worldState startThenBrowseMessageTally ]
]

{ #category : #opening }
TimeProfiler class >> onBlock: block [
	"Open a profile browser on the given block, thereby running the block and
	 collecting the message tally."

	| inst result |
	inst := self new.
	result := inst runBlock: block.
	inst open.
	inst showResult: result.
	^ result
]

{ #category : #'tools-registry' }
TimeProfiler class >> registerToolsOn: registry [
	"Add ourselves to registry. See [Smalltalk tools]"
	registry register: self as: #timeProfiler
]

{ #category : #opening }
TimeProfiler class >> spyAllOn: aBlock [
	"Spy on all the processes in the system"
	| inst result |
	inst := self new.
	result := inst spyAllOn: aBlock.
	inst open.
	inst showResult: result.
	^ result
]

{ #category : #opening }
TimeProfiler class >> spyFor: seconds [
	"Run the system profiler for the specified number of seconds"

	^self spyOn: [ (Delay forSeconds: seconds) wait ]
]

{ #category : #opening }
TimeProfiler class >> spyOn: aBlock [
	^ (self new withBlockCodePane: false; withToolBar: false; yourself)
		openOnBlock: aBlock
]

{ #category : #opening }
TimeProfiler class >> spyOnProcess: aProcess forMilliseconds: msecDuration [
	"Run aProcess for msecDuration milliseconds, then open a TimeProfiler on the results."

	| inst |
	inst := self new.
	inst withBlockCodePane: false.
	inst runProcess: aProcess forMilliseconds: msecDuration pollingEvery: MessageTally defaultPollPeriod.
	inst open.
	^ inst
]

{ #category : #icons }
TimeProfiler class >> taskbarIconName [
	^#smallProfile
]

{ #category : #actions }
TimeProfiler >> blockCode [
	^ block
		ifNil: ['']
		ifNotNil: [ blockSource ifNil: [ blockSource := block asString ]]
]

{ #category : #actions }
TimeProfiler >> blockCode: aString notifying: aRequestor [
	"Treat the current selection as an expression; evaluate and tally it."
	|  compiledMethod |
	aString ifNil: [^ self].
	blockSource := aString.
	compiledMethod := Smalltalk compiler
		source: ('self runBlock: [', aString, ']');
		context: self doItContext;
		requestor: self;
		noPattern: true;
		failBlock: [^self];
		compile.
	self showResult: ( compiledMethod valueWithReceiver: self arguments: #()).
	self changed: #blockCode.
	self changed: #summaryText.
	self changed: #fullReport.
	self selection: nil.
	self updateList.
	self startState
]

{ #category : #actions }
TimeProfiler >> browseItem [
	self selectedNode ifNotNil: [:current | current browseItem ]
]

{ #category : #'ui specific' }
TimeProfiler >> codePaneMenu: aMenu shifted: shifted [
	"Note that unless we override perform:orSendTo:,
	PluggableTextController will respond to all menu items in a
	text pane"
	| donorMenu |
   donorMenu := (PragmaMenuBuilder pragmaKeyword: RubSmalltalkCodeMode menuKeyword model: codeTabPane) menu.
	^ aMenu addAllFrom: donorMenu
]

{ #category : #'ui specific' }
TimeProfiler >> contentsSelection [
	"Return the interval of text in the code pane to select when I set the pane's contents"

	^ 1 to: 0		"null selection"
]

{ #category : #'ui specific' }
TimeProfiler >> correctFrom: start to: stop with: aString [
	^ blockCodePane correctFrom: start to: stop with: aString
]

{ #category : #actions }
TimeProfiler >> deselect [
	blockCodePane deselect
]

{ #category : #actions }
TimeProfiler >> doItContext [
	"Answer the context in which a text selection can be evaluated."

	^nil
]

{ #category : #actions }
TimeProfiler >> doItReceiver [
	"This class's classPool has been jimmied to be the classPool of the class
	being browsed. A doIt in the code pane will let the user see the value of
	the class variables."

	^ self selectedClass
]

{ #category : #actions }
TimeProfiler >> expandAll [
	treeMorph expandAllSuchThat: [:node | node percentage > self minPercentageToExpand]
]

{ #category : #'accessing - computed' }
TimeProfiler >> fullReport [
	"Return the full report of the tally "
	^ String streamContents: [:strm |
		rootMessageTally
			ifNotNil: [ rootMessageTally report: strm ] ]
]

{ #category : #'ui specific' }
TimeProfiler >> fullReportMenu: aMenuMorph shift: aBoolean [
	^ (PragmaMenuBuilder
		pragmaKeyword: 'TimeProfilerFullReportMenu'
		model: self) menu
]

{ #category : #configuration }
TimeProfiler >> helpMessage [

^'You can edit some code in the top editor and accept to profile it.
The result consists in a tree of method calls shown in the middle panel.
Select a method call to see or change its implementation in the bottom editor.

Tallies building:
The tallies are built according to the time threshold value that you can change at the top right (Treshold input field).

Tree expanding:
A tree node is expanded only if its duration percentage is greater that the minimum value that you can change at the top left (Min duration percentage input field).
'
]

{ #category : #configuration }
TimeProfiler >> initialExtent [
	^ 750 @ 700
]

{ #category : #'ui specific' }
TimeProfiler >> keyDown: anEvent from: aTreeMorph [
	self selectedNode ifNotNil: [:current | current keyDown: anEvent from: aTreeMorph ]
]

{ #category : #'accessing - computed' }
TimeProfiler >> leaveItems [
	| res  |
	res := OrderedCollection new.
	rootMessageTally
		ifNotNil: [
			| dict |
			dict := IdentityDictionary new: 100.
			rootMessageTally leavesInto: dict fromSender: nil.
			res addAll: (dict asOrderedCollection select: [ :node | node tally > self threshold ]) ].
	^ res
]

{ #category : #'ui specific' }
TimeProfiler >> menu: menu shifted: b [
	"Set up the menu to apply to the receiver's, honoring the #shifted boolean"

	self selectedNode
		ifNotNil: [ :current |
			current menu: menu shifted: b.
			menu addLine.
			menu
				add: 'Expand all from here'
				target: self
				selector: #expandAllFromNode:
				argument: current ].
	^ menu
]

{ #category : #'ui specific' }
TimeProfiler >> minPercentageToExpand [
	^ minPercentageToExpand ifNil: [minPercentageToExpand := 3.0]
]

{ #category : #'ui specific' }
TimeProfiler >> minPercentageToExpand: aPercentage [
	minPercentageToExpand := aPercentage.
	self changed: #minPercentageToExpand
]

{ #category : #'ui specific' }
TimeProfiler >> notify: aString at: anInteger in: aStream [
	blockCodePane notify: aString at: anInteger - 'self runBlock: [' size in: aStream
]

{ #category : #'public opening' }
TimeProfiler >> open [
	"Public method. This method simply open a time profiler"

	| toolBar codePane vgap summaryPane blkPaneGap treeTopFraction treeTabPane fullReportPane |
	win := StandardWindow new model: self.
	win setLabel: self toolName.
	toolBar := self toolBarOn: win.
	treeMorph := self treeMorph
		buildContents;
		yourself.
	summaryPane := win
		newTextEditorFor: self
		getText: #summaryText
		setText: nil
		getEnabled: nil.
	fullReportPane := win
		newTextEditorFor: self
		getText: #fullReport
		setText: nil
		getEnabled: nil.
	fullReportPane getMenuSelector: #fullReportMenu:shift:.
	codePane := win
		newTextEditorFor: self
		getText: #selectedMethodCode
		setText: #selectedMethodCode:notifying:
		getEnabled: nil.

	codePane getMenuSelector: #codePaneMenu:shifted:.
	codePane font: StandardFonts codeFont.
	self withToolBar
		ifTrue: [
			vgap := toolBar minExtent y.
			win addMorph: toolBar fullFrame: ((0 @ 0 corner: 1 @ 0) asLayoutFrame bottomOffset: vgap) ]
		ifFalse: [ vgap := 0 ].
	blkPaneGap := 0.
	treeTopFraction := 0.0.
	self withBlockCodePane
		ifTrue: [
			blkPaneGap := 10.
			treeTopFraction := 0.15.
			blockCodePane := win
				newTextEditorFor: self
				getText: #blockCode
				setText: #blockCode:notifying:
				getEnabled: nil.
			blockCodePane getMenuSelector: #codePaneMenu:shifted:.
			blockCodePane font: StandardFonts codeFont.
			blockCodePane alwaysAccept: true.
			win
				addMorph: blockCodePane
				fullFrame:
					((0 @ 0 corner: 1 @ treeTopFraction) asLayoutFrame
						topOffset: vgap;
						bottomOffset: vgap + blkPaneGap) ].
	treeTabPane := win
		newTabGroup:
			{('Tallies Tree' -> treeMorph).
			('Full report' -> fullReportPane)}.
	win addMorph: treeTabPane fullFrame: ((0 @ treeTopFraction corner: 1 @ 0.6) asLayoutFrame topOffset: vgap + blkPaneGap).
	win
		addMorph:
			(codeTabPane := win
				newTabGroup:
					{('Code' -> codePane).
					('Statistics' -> summaryPane)})
		fullFrame: (0 @ 0.6 corner: 1 @ 1) asLayoutFrame.
	win openInWorld.
	self startState
]

{ #category : #'public opening' }
TimeProfiler >> openOnBlock: aBlock [
	self runBlock: aBlock pollingEvery: MessageTally defaultPollPeriod.
	self open.
	^ self
]

{ #category : #'public opening' }
TimeProfiler >> openPathFrom: aNode [
	self expandNodePath: aNode path
]

{ #category : #actions }
TimeProfiler >> profileIt [
	blockCodePane accept
]

{ #category : #'ui specific' }
TimeProfiler >> reportOtherProcesses [
	^ reportOtherProcesses ifNil: [reportOtherProcesses := true]
]

{ #category : #'ui specific' }
TimeProfiler >> reportOtherProcesses: aBoolean [
	self reportOtherProcesses ~= aBoolean
		ifFalse: [ ^ self ].
	reportOtherProcesses := aBoolean.
	self changed: #reportOtherProcesses.
	self updateList
]

{ #category : #accessing }
TimeProfiler >> result: anObject [
	result := anObject
]

{ #category : #'accessing - computed' }
TimeProfiler >> resultText [
	^ result printString
]

{ #category : #'accessing - computed' }
TimeProfiler >> rootItems [
	^ rootMessageTally
		ifNil: [#()]
		ifNotNil: [
			self showLeavesOnly
				ifTrue: [ self leaveItems ]
				ifFalse: [ self rootTallyItems]]
]

{ #category : #accessing }
TimeProfiler >> rootNodeClassFromItem: anItem [
	^ TimeProfilerNode
]

{ #category : #'accessing - computed' }
TimeProfiler >> rootTallyItems [
	| res sons groups |
	res := OrderedCollection new.
	rootMessageTally
		ifNotNil: [
			sons := rootMessageTally sonsOver: self threshold.
			groups := sons groupedBy: [ :aTally | aTally process ] having: [ :g | true ].
			groups
				do: [ :g |
					self reportOtherProcesses
						ifTrue: [ res addAll: g ]
						ifFalse: [ res addAll: (g asSortedCollection reject: [ :gg | gg process isNil ]) ] ] ].
	^ res
]

{ #category : #actions }
TimeProfiler >> runBlock: aBlock [
	^ self runBlock: aBlock pollingEvery: MessageTally defaultPollPeriod
]

{ #category : #actions }
TimeProfiler >> runBlock: aBlock pollingEvery: pollPeriod [
	block := aBlock.
	rootMessageTally := MessageTally new.
	rootMessageTally
		reportOtherProcesses: true;
		maxClassNameSize: 1000;
		maxClassPlusSelectorSize: 1000;
		maxTabs: 100.
	result := rootMessageTally spyEvery: pollPeriod on: aBlock.
	self result: result.
	^ result
]

{ #category : #actions }
TimeProfiler >> runProcess: aProcess forMilliseconds: msecDuration pollingEvery: pollPeriod [
	block := MessageSend
				receiver: self
				selector: #runProcess:forMilliseconds:pollingEvery:
				arguments: {
						aProcess.
						msecDuration.
						pollPeriod}.	"so we can re-run it"
	rootMessageTally := MessageTally new.
	rootMessageTally
		reportOtherProcesses: false;
		maxClassNameSize: 1000;
		maxClassPlusSelectorSize: 1000;
		maxTabs: 100.
	result := rootMessageTally
				spyEvery: pollPeriod
				onProcess: aProcess
				forMilliseconds: msecDuration.
	^result
]

{ #category : #'ui specific' }
TimeProfiler >> select [
	blockCodePane select
]

{ #category : #'ui specific' }
TimeProfiler >> selectFrom: start to: stop [
	blockCodePane  selectFrom: start to: stop
]

{ #category : #'ui specific' }
TimeProfiler >> selectInvisiblyFrom:  first to:  last [
	blockCodePane selectInvisiblyFrom: first to: last
]

{ #category : #accessing }
TimeProfiler >> selectedClass [
	^ self selectedNode
		ifNotNil: [ :currNode | currNode methodClass ]
]

{ #category : #'accessing - computed' }
TimeProfiler >> selectedMethodCode [
	| node method |
	node := self selectedNode.
	node ifNil: [ ^ self helpMessage ].
	method := (node methodClass lookupSelector: node selector) ifNil: [ ^'Method not found' ].
	^method sourceCode
]

{ #category : #compiling }
TimeProfiler >> selectedMethodCode: aString notifying: aController [
	"Compile the code in aString. Notify aController of any syntax errors.
	Answer false if the compilation fails. Otherwise answer true."

	^ self selectedNode
		ifNil: [ false ]
		ifNotNil: [ :currNode |
			| class oldSelector category newSelector |
			class := currNode methodClass.
			oldSelector := currNode selector.
			class ifNil: [ ^ false ].	"Normal method accept"
			category := class organization categoryOfElement: oldSelector.
			newSelector := class compile: aString classified: category notifying: aController.
			newSelector ifNil: [ ^ false ].
			self changed: #selectedMethodCode.
			true ]
]

{ #category : #accessing }
TimeProfiler >> selection: aSelection [
	super selection: aSelection.
	self changed: #selectedMethodCode
]

{ #category : #'ui specific' }
TimeProfiler >> selectionInterval [
	^ 1 to: 0
]

{ #category : #'ui specific' }
TimeProfiler >> shoutAboutToStyle: aPluggableShoutMorphOrView [
	self selectedNode
		ifNotNil: [ :currNode |
			aPluggableShoutMorphOrView getTextSelector = #selectedMethodCode
				ifTrue: [aPluggableShoutMorphOrView classOrMetaClass: currNode methodClass.
					^ true]].
	aPluggableShoutMorphOrView getTextSelector = #summaryText
			ifTrue: [^ false].
	aPluggableShoutMorphOrView getTextSelector = #blockCode
			ifTrue: [^ true].
	 ^ false
]

{ #category : #'ui specific' }
TimeProfiler >> showLeavesOnly [
	^ showLeavesOnly ifNil: [showLeavesOnly := false]
]

{ #category : #'ui specific' }
TimeProfiler >> showLeavesOnly: aBoolean [
	self showLeavesOnly ~= aBoolean
		ifFalse: [ ^ self ].
	treeMorph
		treeLineWidth:
			(aBoolean
				ifTrue: [ 0 ]
				ifFalse: [ 1 ]).
	showLeavesOnly := aBoolean.
	self changed: #showLeavesOnly.
	self updateList
]

{ #category : #'ui specific' }
TimeProfiler >> showResult: anObject [
	self result: anObject.
	resultPane
		ifNil: [resultPane := win
			newTextEditorFor: self
			getText: #resultText
			setText: nil
			getEnabled: nil.
			codeTabPane addPage: resultPane label: 'Result']
		ifNotNil: [self changed: #resultText]
]

{ #category : #actions }
TimeProfiler >> spyAllOn: aBlock [
	block := aBlock.
	rootMessageTally := MessageTally new.
	rootMessageTally
		reportOtherProcesses: true;
		maxClassNameSize: 1000;
		maxClassPlusSelectorSize: 1000;
		maxTabs: 100.
	result := rootMessageTally spyAllEvery: MessageTally defaultPollPeriod on: aBlock.
	self result: result.
	^ result
]

{ #category : #configuration }
TimeProfiler >> startMinPercentageToExpand [
	^ 20
]

{ #category : #'ui specific' }
TimeProfiler >> startState [
	treeMorph expandAllSuchThat: [:node | node percentage > self startMinPercentageToExpand]
]

{ #category : #'accessing - computed' }
TimeProfiler >> summaryText [
	^ String streamContents: [:strm | rootMessageTally
		ifNotNil: [rootMessageTally time > 0
			ifTrue: [strm nextPutAll: ' - '; print: rootMessageTally tally; nextPutAll: ' tallies, ', rootMessageTally time printString, ' msec.'; cr.
				rootMessageTally reportGCStatsOn: strm]]]
]

{ #category : #accessing }
TimeProfiler >> tally [
	^ rootMessageTally tally
]

{ #category : #accessing }
TimeProfiler >> text [
	^ blockSource
]

{ #category : #accessing }
TimeProfiler >> threshold [
	^ threshold ifNil: [threshold := 0]
]

{ #category : #accessing }
TimeProfiler >> threshold: aTreshold [
	(aTreshold ~= threshold and: [ aTreshold between: 0 and: 1000 ])
		ifFalse: [ ^ self ].
	threshold := aTreshold.
	self updateList.
	self changed: #threshold
]

{ #category : #accessing }
TimeProfiler >> time [
	^ rootMessageTally time
]

{ #category : #'ui specific' }
TimeProfiler >> toolBarOn: aWindow [
	| uiTheme toolBar |
	uiTheme :=self theme.
	toolBar := toolBar := aWindow
		newToolbar:
			{((uiTheme
				newButtonIn: self
				for: self
				getState: nil
				action: #profileIt
				arguments: {}
				getEnabled: nil
				getLabel: nil
				help: nil)
				label:
					(uiTheme
						newRowIn: self
						for:
							{(AlphaImageMorph new
								image: (self iconNamed: #smallDoIt)).
							(uiTheme buttonLabelForText: 'Profile it' translated)});
				yourself).
			aWindow newToolSpacer.
			aWindow newToolSpacer.
			(aWindow newLabel: 'Min time % ' translated).
			(uiTheme
				newTextEntryIn: aWindow
				for: self
				get: #minPercentageToExpand
				set: #minPercentageToExpand:
				class: Float
				getEnabled: nil
				help: nil).
			aWindow newToolSpacer.
			aWindow newToolSpacer.
			(aWindow newLabel: 'Threshold: ' translated).
			(uiTheme
				newTextEntryIn: aWindow
				for: self
				get: #threshold
				set: #threshold:
				class: Integer
				getEnabled: nil
				help: nil).
			aWindow newToolSpacer.
			aWindow newToolSpacer.
			(aWindow
				newDropListFor: self
				list: #whatToShowList
				getSelected: #whatToShow
				setSelected: #whatToShow:
				getEnabled: nil
				useIndex: false
				help: 'Which kind of result').
			aWindow newToolSpacer.
			aWindow newToolSpacer.
			(uiTheme
				newCheckboxIn: self
				for: self
				getSelected: #reportOtherProcesses
				setSelected: #reportOtherProcesses:
				getEnabled: nil
				label: 'All processes'
				help: nil).
			aWindow newToolSpacer}.
	^ toolBar
]

{ #category : #configuration }
TimeProfiler >> toolName [
	^ 'Time profiler'
]

{ #category : #'ui specific' }
TimeProfiler >> treeMorph [
	^ (self treeMorphClass on: self)
		rowInset: 2;
		columnInset: 4;
		autoDeselection: true;
		getMenuSelector:#menu:shifted:;
		keyDownActionSelector: #keyDown:from:;
		treeLineWidth: 1;
		treeLineDashes: {5. 1};
		lineColorBlock: [:node | {Color gray. Color orange. Color brown. Color magenta. Color blue} at: ((node level \\ 5) + 1)];
		doubleClickSelector: #browseItem;
		rowColorForEven: self theme lightBackgroundColor;
		yourself
]

{ #category : #'ui specific' }
TimeProfiler >> whatToShow [
	^ self showLeavesOnly ifTrue: [#'Leaves'] ifFalse: [#'Full tree']
]

{ #category : #'ui specific' }
TimeProfiler >> whatToShow: aSymbol [
	self showLeavesOnly: aSymbol = #'Leaves'
]

{ #category : #configuration }
TimeProfiler >> whatToShowList [
	^ #(#'Full tree' #'Leaves')
]

{ #category : #'ui specific' }
TimeProfiler >> withBlockCodePane [
	^ withBlockCodePane ifNil: [withBlockCodePane := true]
]

{ #category : #'ui specific' }
TimeProfiler >> withBlockCodePane: aBoolean [
	withBlockCodePane := aBoolean
]

{ #category : #'ui specific' }
TimeProfiler >> withToolBar [
	^ withToolBar ifNil: [withToolBar := true]
]

{ #category : #'ui specific' }
TimeProfiler >> withToolBar: aBoolean [
	withToolBar := aBoolean
]
