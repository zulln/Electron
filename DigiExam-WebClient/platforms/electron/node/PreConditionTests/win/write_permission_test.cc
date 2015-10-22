#include "write_permission_test.h"

namespace precondition {

	bool WritePermissionTest::isFailFatal(){ return WritePermissionTest::_isFailFatal;}
	bool WritePermissionTest::isSuccess(){ return WritePermissionTest::_isSuccess;}
	void WritePermissionTest::startTest(v8::Local<v8::Function> callback){
		Isolate* isolate = Isolate::GetCurrent();
		const unsigned argc = 1;

		/*
			Windows implementation here
		*/

		TestObjectFactory* testObjFactory = new TestObjectFactory();
		Local<Object> jsTestObject = testObjFactory->createTestObject(this);
		Local<Value> argv[argc] = { jsTestObject };
		callback->Call(isolate->GetCurrentContext()->Global(), argc, argv);
	}

	std::string WritePermissionTest::failTitle(){ return WritePermissionTest::_failTitle;}
	std::string WritePermissionTest::failMessage(){ return WritePermissionTest::_failMessage;}

}
