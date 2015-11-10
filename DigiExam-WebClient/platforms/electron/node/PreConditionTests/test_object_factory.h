#ifndef TEST_OBJECT_FACTOR_H
#define TEST_OBJECT_FACTOR_H
#include <string>
#include <node.h>
#include "base_precondition_test.h"

using namespace v8;

namespace precondition {

	class TestObjectFactory
	{
	public:
		Local<Object> createTestObject(BasePreConditionTest* t);
	};

}
#endif
