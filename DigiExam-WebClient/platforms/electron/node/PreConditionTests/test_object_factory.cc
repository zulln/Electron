#include "test_object_factory.h"

namespace precondition {

	Local<Object> TestObjectFactory::createTestObject(BasePreConditionTest* t) {
		Isolate* isolate = Isolate::GetCurrent();
		Local<Object> jsTestObject = Object::New(isolate);

		jsTestObject->Set(String::NewFromUtf8(isolate, "failTitle"), String::NewFromUtf8(isolate, t->failTitle().c_str()));
		jsTestObject->Set(String::NewFromUtf8(isolate, "failMessage"), String::NewFromUtf8(isolate, t->failMessage().c_str()));
		jsTestObject->Set(String::NewFromUtf8(isolate, "isFailFatal"), Boolean::New(isolate, t->isFailFatal()));
		jsTestObject->Set(String::NewFromUtf8(isolate, "isSuccess"),  Boolean::New(isolate, t->isSuccess()));

		return jsTestObject;
	}

}
