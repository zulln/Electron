#ifndef TEST_OBJECT_FACTOR_H
#define TEST_OBJECT_FACTOR_H
#import <string>
#import <node.h>
#import "base_precondition_test.h"

using namespace v8;

namespace precondition {

	class TestObjectFactory
	{
	public:
		virtual Local<Object> createTestObject(BasePreConditionTest* t);
	};
	
}
#endif
