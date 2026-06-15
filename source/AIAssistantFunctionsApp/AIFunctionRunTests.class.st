Class {
	#name : 'AIFunctionRunTests',
	#superclass : 'AIAbstractFunction',
	#category : 'AIAssistantFunctionsApp'
}

{ #category : 'Actions' }
AIFunctionRunTests >> applyFunctionTo: arguments in: context [
	| testClasses suite result |
	
	testClasses := (arguments at: 'classes') 
		collect: [ :className | Smalltalk at: className asSymbol ifAbsent: [ nil ] ].
	
	"Filter out invalid or non-TestCase classes"
	testClasses := testClasses select: [ :cls | cls notNil and: [ cls inheritsFrom: TestCase ] ].

	testClasses isEmpty ifTrue: [
		^ EsOrderedDictionary new
			at: 'error' put: 'No valid test classes provided.';
			yourself
	].

	"Build a suite for the classes and run it"
	suite := TestSuite forClasses: testClasses.
	result := suite run.

	"Return an EsOrderedDictionary containing the results"
	^ EsOrderedDictionary new
		at: 'runCount' put: result runCount;
		at: 'passedCount' put: result passedCount;
		at: 'failureCount' put: result failureCount;
		at: 'errorCount' put: result errorCount;
		at: 'failures' put: (result failures collect: [ :testCase | testCase printString ]) asArray;
		at: 'errors' put: (result errors collect: [ :testCase | testCase printString ]) asArray;
		yourself
]

{ #category : 'Accessing' }
AIFunctionRunTests >> description [

	^ 'Runs a given list of SUnit test classes and returns the test execution results, including the count of tests run, passed, failed, and encountered errors, as well as a list of failing and erroring test selectors.'
]

{ #category : 'Accessing' }
AIFunctionRunTests >> name [

	^ 'run_test_cases'
]

{ #category : 'Accessing' }
AIFunctionRunTests >> parameters [

	^ {
		AIFunctionParameterRequired name: 'classes'
			type: (AIFunctionParameterTypeArray itemsType: AIFunctionParameterTypeString new)
			description: 'Names of the test classes to run.' }
]
