Class {
	#name : 'AIJSONSerializationTest',
	#superclass : 'TestCase',
	#category : 'AIAssistantTestsApp'
}

{ #category : 'Tests' }
AIJSONSerializationTest >> testClassAIJSON [

	| json |

	json := AIJSONMockClass aiJSON.
	self assert: json class equals: EsOrderedDictionary.
	self assert: json keys size equals: 5.
	self assert: (json at: 'superclass') equals: 'Object'.
	self assert: (json at: 'instance_variables') equals: #('var1' 'var2').
	self assert: (json at: 'class_variables') equals: #('AClassVar3' 'ClassVar1' 'ZClassVar2').
	self assert: (json at: 'pool_dictionaries') equals: #('CldtConstants').
	self assert: (json at: 'application') equals: 'AIAssistantTestsApp'
]

{ #category : 'tests' }
AIJSONSerializationTest >> testClassSideCompiledMethodAIJSON [

	| json |

	json := (AIJSONMockClass class >> #mockClassMethod) aiJSON.
	self assert: json class equals: EsOrderedDictionary.
	self assert: json keys size equals: 7.
	self assert: (json at: 'class') equals: 'AIJSONMockClass'.
	self assert: (json at: 'side') equals: 'class'.
	self assert: (json at: 'application') equals: 'AIAssistantTestsApp'.
	self assert: (json at: 'is_private') equals: false.
	self assert: (json at: 'categories') equals: (OrderedCollection with: 'mock').
	self assert: (json at: 'selector') equals: 'mockClassMethod'.
	self
		assert: (json at: 'source')
		equals: (CldtConstants::LineDelimiter join: { 'mockClassMethod'. (String with: Character tab) , '^ ''this is a mock class method''' })
]

{ #category : 'Tests' }
AIJSONSerializationTest >> testCompiledMethodAIJSON [

	| json |

	json := (AIJSONMockClass >> #mockMethod) aiJSON.
	self assert: json class equals: EsOrderedDictionary.
	self assert: json keys size equals: 7.
	self assert: (json at: 'class') equals: 'AIJSONMockClass'.
	self assert: (json at: 'side') equals: 'instance'.
	self assert: (json at: 'application') equals: 'AIAssistantTestsApp'.
	self assert: (json at: 'is_private') equals: false.
	self assert: (json at: 'categories') equals: (OrderedCollection with: 'mock').
	self assert: (json at: 'selector') equals: 'mockMethod'.
	self
		assert: (json at: 'source')
		equals: (CldtConstants::LineDelimiter join: { 'mockMethod'. (String with: Character tab) , '^ ''this is a mock method''' })
]

{ #category : 'tests' }
AIJSONSerializationTest >> testExtensionMethodAIJSON [

	| json method |

	method := CompiledMethod >> #aiJSON.
	json := method aiJSON.
	self assert: json class equals: EsOrderedDictionary.
	self assert: json keys size equals: 7.
	self assert: (json at: 'class') equals: 'CompiledMethod'.
	self assert: (json at: 'side') equals: 'instance'.
	self assert: (json at: 'application') equals: 'AIAssistantFunctionsApp'.
	self assert: (json at: 'is_private') equals: false.
	self assert: (json at: 'categories') equals: (OrderedCollection with: 'AIAssistant').
	self assert: (json at: 'selector') equals: 'aiJSON'.
	self assert: (json at: 'source') equals: method sourceString
]
